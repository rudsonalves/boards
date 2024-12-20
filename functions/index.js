// Configurações para conectar ao emulador
if (process.env.FUNCTIONS_EMULATOR === "true") {
  process.env.FIRESTORE_EMULATOR_HOST = "127.0.0.1:8080";
  process.env.FIREBASE_AUTH_EMULATOR_HOST = "127.0.0.1:9099";
}

// Importações necessárias
const {onDocumentCreated, onDocumentDeleted} =
    require("firebase-functions/v2/firestore");
const {onCall, onRequest, HttpsError} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const {getFirestore} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");
const {FieldValue} = require("firebase-admin/firestore");
const {defineSecret} = require("firebase-functions/params");
const stripe = require("stripe");

require("dotenv").config();

// Inicializar o Firebase Admin SDK
admin.initializeApp();
const firestore = admin.firestore();
const auth = admin.auth();
const db = admin.firestore();

// Defina os segredos utilizando o Firebase Secret Manager
const STRIPE_API_KEY = defineSecret("STRIPE_API_KEY");
const WEBHOOK_SEC = defineSecret("WEBHOOK_SEC");

/** =====================
 *  Funções do Stripe
 *  =====================
 */

/**
 * Função que lida com o recebimento de webhooks do Stripe, validando a
 * assinatura e processando eventos como conclusão ou falha de checkout.
 *
 * @function stripeWebhook
 * @param {Object} request - Objeto de requisição HTTP do Firebase Functions.
 * @param {Object} response - Objeto de resposta HTTP do Firebase Functions.
 * @description
 * Esta função é acionada quando o Stripe envia um evento (webhook) para o
 * endpoint.
 * Ela valida a origem e a integridade do evento, processa-o de acordo com
 * seu tipo, e envia uma resposta apropriada (200 para sucesso, 400 ou 500
 * para erros).
 *
 * @throws {Error} - Lança erro caso não seja possível validar o webhook,
 *                   processar o evento ou acessar as chaves de ambiente.
 */
exports.stripeWebhook = onRequest(
    {
      region: "southamerica-east1",
      secrets: [STRIPE_API_KEY, WEBHOOK_SEC],
      maxInstances: 1,
      enforceRawBody: true,
    },
    async (request, response) => {
      try {
        console.log("Starting webhook.");

        // Inicializa a instância do Stripe
        const stripeInstance = initializeStripe(request);

        // Valida o evento recebido do Stripe
        const event = validateWebhook(request, stripeInstance);

        console.log(`Evento Stripe validado: ${event.type}`);
        // Processa o evento do Stripe
        await processStripeEvent(event);

        response.status(200).send("Webhook processado com sucesso");
      } catch (err) {
        console.error(`Erro no webhook: ${err.message}`);
        response.status(err.statusCode || 500)
            .send(`Erro no Webhook: ${err.message}`);
      }
    },
);

/**
 * Inicializa a instância do Stripe usando as chaves de API apropriadas.
 *
 * @param {Object} request - Objeto de requisição HTTP.
 * @return {Object} - Instância do Stripe.
 */
function initializeStripe(request) {
  const stripeApiKey = (request.secret && request.secret.STRIPE_API_KEY) ||
            process.env.STRIPE_API_KEY;

  if (!stripeApiKey) {
    const message = "Stripe API key not configured.";
    console.error(message);
    throw new Error(message);
  }

  return require("stripe")(stripeApiKey);
}

/**
 * Valida o evento recebido do Stripe usando o webhook secret.
 *
 * @param {Object} request - Objeto de requisição HTTP.
 * @param {Object} stripeInstance - Instância do Stripe.
 * @return {Object} - Evento validado do Stripe.
 */
function validateWebhook(request, stripeInstance) {
  const endpointSecret = (request.secret && request.secret.WEBHOOK_SEC) ||
      process.env.WEBHOOK_SEC;

  if (!endpointSecret) {
    console.error("WEBHOOK_SEC is not defined.");
    throw new Error("Webhook secret not configured.");
  }

  const sig = request.headers["stripe-signature"];

  if (!request.rawBody || !(request.rawBody instanceof Buffer)) {
    throw new Error("rawBody is missing or not a Buffer.");
  }

  try {
    return stripeInstance.webhooks.constructEvent(
        request.rawBody,
        sig,
        endpointSecret);
  } catch (err) {
    throw new Error(`Erro ao validar webhook: ${err.message}`);
  }
}

/**
 * Processa o evento do Stripe baseado no tipo.
 *
 * @param {Object} event - Evento validado do Stripe.
 */
async function processStripeEvent(event) {
  switch (event.type) {
    case "checkout.session.completed": {
      await handlePaymentSuccess(event.data.object);
      console.log(`Webhook evento: ${event.type}`);
      break;
    }

    case "checkout.session.expired":
    case "checkout.session.async_payment_failed": {
      await handlePaymentFailure(event.data.object);
      console.log(`Session payment event: ${event.type}`);
      break;
    }

    default: {
      console.log(`Evento não tratado: ${event.type}`);
      break;
    }
  }
}

/**
 * Função que lida com o recebimento de webhooks do Stripe, validando a
 * assinatura e processando eventos como conclusão ou falha de checkout.
 *
 * @function stripeWebhook
 * @param {Object} req - Objeto de requisição HTTP do Firebase Functions.
 * @param {Object} res - Objeto de resposta HTTP do Firebase Functions.
 * @description
 *
 * Esta função é acionada quando o Stripe envia um evento (webhook) para o
 * endpoint.
 * Ela valida a origem e a integridade do evento, processa-o de acordo com
 * seu tipo, e envia uma resposta apropriada (200 para sucesso, 400 ou 500
 * para erros).
 *
 * @throws {Error} - Lança erro caso não seja possível validar o webhook,
 *                   processar o evento ou acessar as chaves de ambiente.
 */
exports.createCheckoutSession = onCall(
    {
      region: "southamerica-east1",
      secrets: [STRIPE_API_KEY],
    },
    async (request) => {
      try {
        // 1. Verificar autenticação do usuário
        const userId = verifyAuth(request);

        // 2. Validar os itens
        const items = validateItems(items);

        // 3. Reservar os itens
        await reserveItems(items, userId);

        // 4. Criar sessão no Stripe
        const sessionUrl = await createStripeSession(items, userId);

        console.log(`session return: ${sessionUrl}`);
        return {url: sessionUrl};
      } catch (error) {
        console.error("Error in createCheckoutSession:", error);
        throw new HttpsError("internal", error.message);
      }
    });


/**
 * Cria um PaymentIntent no Stripe, retornando um client_secret para realizar
 * o pagamento.
 *
 * @function createPaymentIntent
 * @param {Object} request - Objeto da requisição onCall do Firebase Functions.
 * @param {Object} request.data - Dados enviados na requisição, incluindo:
 * @param {Array} request.data.items - Lista de itens (com unit_price e
 *                                     quantity).
 * @param {Object} request.auth - Contexto de autenticação do usuário.
 * @return {Promise<Object>} - Retorna um objeto contendo o clientSecret do
 *                             PaymentIntent.
 * @description
 * 1. Verifica se o usuário está autenticado.
 * 2. Valida a lista de itens.
 * 3. Calcula o valor total dos itens.
 * 4. Cria um PaymentIntent no Stripe e retorna o clientSecret para o front-end.
 *
 * @throws {HttpsError} - Caso o usuário não esteja autenticado, os itens sejam
 *                        inválidos ou ocorra erro ao criar o PaymentIntent.
 */
exports.createPaymentIntent = onCall(
    {
      region: "southamerica-east1",
      secrets: ["STRIPE_API_KEY"],
    },
    async (request) => {
      try {
        // Inicie o Stripe usando a secret do ambiente
        const stripeInstance = initializeStripe(request);

        // Verificar autenticação do usuário
        const userId = verifyAuth(request);

        // Verificar se os itens foram enviados
        const items = validateItems(items);

        // Calcula o valor total em centavos
        const totalAmount = calculateTotal(items);

        // Cria um PaymentIntent no Stripe
        const paymentIntent = await createStripePaymentIntent(stripeInstance, {
          totalAmount,
          userId,
          items,
        });

        return {clientSecret: paymentIntent.client_secret};
      } catch (error) {
        console.error("Error in createPaymentIntent:", error);
        throw new HttpsError("internal", error.message);
      }
    });


/**
 * Calcula o valor total em centavos baseado nos itens fornecidos.
 *
 * @function calculateTotal
 * @param {Array} items - Lista de itens, cada um contendo unit_price e
 *                        quantity.
 * @return {number} - Valor total calculado em centavos.
 */
function calculateTotal(items) {
  return items.reduce((total, item) => {
    return total + Math.round(item.unit_price * 100) * item.quantity;
  }, 0);
}


/**
 * Cria um PaymentIntent no Stripe.
 *
 * @function createStripePaymentIntent
 * @param {Object} stripeInstance - Instância inicializada do Stripe.
 * @param {Object} params - Parâmetros para o PaymentIntent.
 * @param {number} params.totalAmount - Valor total em centavos.
 * @param {string} params.userId - UID do usuário.
 * @param {Array} params.items - Lista de itens para o pagamento.
 * @return {Promise<Object>} - Objeto do PaymentIntent criado.
 */
async function createStripePaymentIntent(stripeInstance,
    {totalAmount, userId, items}) {
  return stripeInstance.paymentIntents.create({
    amount: totalAmount,
    payment_method_types: ["card"],
    description: "Compra de produtos",
    currency: "brl",
    metadata: {
      userId,
      items: JSON.stringify(items),
    },
  });
}


// ==============================
// Funções auxiliares do Webhook
// ==============================

/**
 * Trata o evento de sucesso no pagamento do Stripe, removendo reservas
 * dos itens já comprados.
 *
 * @async
 * @function handlePaymentSuccess
 * @param {Object} session - Objeto da sessão do Stripe (checkout.session).
 * @description
 * Extrai o userId e itens do metadata da sessão, remove as reservas
 * correspondentes do Firestore, confirmando assim a compra do(s) item(ns).
 *
 * @throws {Error} - Caso falte metadata ou items no session.
 */
async function handlePaymentSuccess(session) {
  console.log(`Starting handlePaymentSuccess:`);
  const metadata = session.metadata;
  if (!metadata || !metadata.items || !metadata.userId) {
    console.error("Metadata missing in session:", session.id);
    return;
  }

  const items = JSON.parse(metadata.items);
  const userId = metadata.userId;

  const batch = db.batch();

  for (const item of items) {
    const reserveRef = db
        .collection("ads")
        .doc(item.adId)
        .collection("reserve")
        .doc(userId);

    // Remove a reserva ao confirmar a venda
    batch.delete(reserveRef);
  }

  await batch.commit();
  console.log(`Payment confirmed and reservations cleared for user: ${userId}`);
}


/**
 * Trata eventos de falha ou expiração do checkout do Stripe, restaurando o
 * estoque dos itens e removendo as reservas.
 *
 * @async
 * @function handlePaymentFailure
 * @param {Object} session - Objeto da sessão do Stripe (checkout.session).
 * @description
 * Extrai o userId e itens do metadata, restaura a quantidade original dos
 * produtos no estoque do Firestore e remove as reservas, já que o pagamento
 * não foi concluído.
 *
 * @throws {Error} - Caso falte metadata ou items no session.
 */
async function handlePaymentFailure(session) {
  console.log(`Starting handlePaymentFailure:`);
  const metadata = session.metadata;
  if (!metadata || !metadata.items || !metadata.userId) {
    console.error("Metadata missing in session:", session.id);
    return;
  }

  const items = JSON.parse(metadata.items);
  const userId = metadata.userId;

  const batch = db.batch();

  for (const item of items) {
    const adRef = db.collection("ads").doc(item.adId);
    const reserveRef = adRef.collection("reserve").doc(userId);

    const reservedQty = item.quantity;

    // Restaurar o estoque
    batch.update(adRef, {
      quantity: FieldValue.increment(reservedQty),
    });

    // Remove reserva
    batch.delete(reserveRef);
    console.log(`Restoring stock for user: ${userId},
        adId: ${item.adId}, qty: ${item.quantity}`);
  }

  await batch.commit();
  console.log(`Restoring stock for user: ${userId}`);
}


// ===================================
// Funções Relacionadas a Boardgames
// ===================================

/**
 * Notifica um usuário específico sobre uma nova mensagem adicionada a
 * um anúncio.
 *
 * @function notifySpecificUser
 * @param {Object} event - Evento Firestore onDocumentCreated.
 * @param {Object} event.data - Documento criado no Firestore.
 * @param {Object} event.params - Parâmetros da rota, incluindo adId e
 *                                messageId.
 * @description
 * Ao criar um novo documento em "ads/{adId}/messages/{messageId}", esta função:
 * 1. Obtém dados do destinatário da mensagem (targetUserId).
 * 2. Busca o token FCM do usuário.
 * 3. Envia uma notificação push informando sobre a nova mensagem.
 *
 * @throws {Error} - Caso não exista documento do usuário ou FCM token.
 */
exports.notifySpecificUser = onDocumentCreated(
    {
      document: "ads/{adId}/messages/{messageId}",
      region: "southamerica-east1",
    }, async (event) => {
      try {
        const snapshot = event.data; // O documento criado
        if (!snapshot) {
          console.error("No document snapshot available.");
          return;
        }

        const messageData = snapshot.data();
        const adId = event.params.adId;
        const targetUserId = messageData.targetUserId;

        if (!targetUserId) {
          console.error("No target userId found for notification.");
          return;
        }

        // Buscar o token FCM do destinatário
        const firestore = getFirestore();
        const userDoc = await firestore.collection("users")
            .doc(targetUserId)
            .get();

        if (!userDoc.exists) {
          console.error(`No user document found for userId: ${targetUserId}`);
          return;
        }

        const userData = userDoc.data();
        const fcmToken = userData.fcmToken;
        const msgTitle = userData.title;

        if (!fcmToken) {
          console.error(`No FCM token found for userId: ${targetUserId}`);
          return;
        }

        // Configurar a notificação
        const notification = {
          notification: {
            title: "Nova mensagem da Boards",
            body: `${messageData.senderName || "Alguém"}
                enviou/respondeu uma mensagem no anúncio ${msgTitle}.`,
          },
          token: fcmToken,
          data: {
            adId: adId, // Passar ID do anúncio para navegação
          },
        };

        // Enviar a notificação
        const messaging = getMessaging();
        await messaging.send(notification);

        console.log(`Notification sent to userId: ${targetUserId},
              Ad: ${adId}, Title: ${msgTitle}`);
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    });


/**
 * Sincroniza um documento recém-criado em "boardgames/{boardgameId}"
 * com a coleção "bgnames", criando ou atualizando o documento correspondente.
 *
 * @function syncBoardgameToBGNames
 * @param {Object} event - Evento Firestore onDocumentCreated.
 * @param {Object} event.data - Documento criado no Firestore.
 * @param {Object} event.params - Parâmetros da rota, incluindo boardgameId.
 * @description
 * Ao criar um novo boardgame, a função verifica se name e publishYear estão
 * definidos. Cria então um documento em "bgnames/{boardgameId}" formatando o
 * nome e ano.
 *
 * @throws {Error} - Caso faltem campos obrigatórios (name, publishYear).
 */
exports.syncBoardgameToBGNames = onDocumentCreated(
    {
      document: "boardgames/{boardgameId}",
      region: "southamerica-east1",
    },
    async (event) => {
      const newValue = event.data;
      const boardgameId = event.params.boardgameId;

      console.log(
          `Triggered syncBoardgameToBGNames for boardgameId: ${boardgameId}`);
      console.log("Document data received:", newValue);

      // Validação dos campos necessários
      if (!newValue.name || !newValue.publishYear) {
        console.error(`Missing fields in boardgame ${boardgameId}`);
        return;
      }

      const bgNameDoc = {
        name: `${newValue.name} (${newValue.publishYear})`,
        publishYear: newValue.publishYear,
      };

      try {
        await firestore.collection("bgnames")
            .doc(boardgameId)
            .set(bgNameDoc);
        console.log(
            `Successfully synced boardgame ${boardgameId} to bgnames`);
      } catch (error) {
        console.error(`Error syncing boardgame ${boardgameId} to bgnames`,
            error);
      }
    });


/**
 * Deleta o documento correspondente em "bgnames/{boardgameId}" ao apagar
 * um boardgame.
 *
 * @function deleteBGName
 * @param {Object} event - Evento Firestore onDocumentDeleted.
 * @param {Object} event.params - Parâmetros da rota, incluindo boardgameId.
 * @description
 * Quando um boardgame é removido de "boardgames/{boardgameId}", esta função
 * busca o documento correspondente em "bgnames/{boardgameId}" e o deleta,
 * caso exista.
 *
 * @throws {Error} - Caso haja falha ao deletar o documento de "bgnames".
 */
exports.deleteBGName = onDocumentDeleted(
    {
      document: "boardgames/{boardgameId}",
      region: "southamerica-east1",
    },
    async (event) => {
      const boardgameId = event.params.boardgameId;
      const bgNameRef = firestore.collection("bgnames").doc(boardgameId);

      try {
        const bgNameSnap = await bgNameRef.get();
        if (bgNameSnap.exists) {
          await bgNameRef.delete();
          console.log(
              `Successfully deleted boardgame ${boardgameId} from bgnames`,
          );
        } else {
          console.log(
              `No corresponding bgnames document for boardgame ${boardgameId}`,
          );
        }
      } catch (error) {
        console.error(
            `Error deleting boardgame ${boardgameId} from bgnames`,
            error);
      }
    });


// =====================
// Funções Gerais
// =====================

/**
 * Atribui a função (role) "user" a um usuário autenticado, definindo custom
 * claims.
 *
 * @function assignDefaultUserRole
 * @param {Object} request - Objeto da requisição onCall do Firebase Functions.
 * @param {Object} request.auth - Contexto de autenticação do usuário.
 * @return {Promise<Object>} - Retorna um objeto com uma mensagem de sucesso.
 * @description
 * Verifica se o usuário está autenticado, atribui o custom claim role = "user".
 * Pode ser ajustado para atribuir role = "admin" durante a inicialização.
 *
 * @throws {Error} - Caso o usuário não esteja autenticado ou haja falha ao
 *                   definir o custom claim.
 */
exports.assignDefaultUserRole = onCall(
    {
      region: "southamerica-east1",
    },
    async (request) => {
      try {
        console.log("Function assignDefaultUserRole called.");

        const context = request.auth;
        // Verificar se o usuário está autenticado
        if (!context) {
          console.error("User is not authenticated.");
          throw new Error("User must be authenticated to call this function.");
        }

        const userId = context.uid;
        if (!userId) {
          console.error("User ID not found in context.");
          throw new Error("Could not extract user ID from token");
        }

        // Definir o role como "user"
        const role = "user";

        // Se for a primeira configuração, descomente a linha abaixo para
        // definir como "admin"
        // const role = "admin";

        await auth.setCustomUserClaims(userId, {role});
        console.log(
            `Custom claims success => user: ${userId} role: ${role}`);

        return {
          message: `Custom claims success => user: ${userId} role: ${role}`,
        };
      } catch (error) {
        console.error("Error assigning default user role:", error);
        throw new Error("Failed to set custom claims");
      }
    });


/**
 * Altera a função (role) de um usuário, requerendo que o chamador seja um
 * "admin".
 *
 * @function changeUserRole
 * @param {Object} request - Objeto da requisição onCall do Firebase Functions.
 * @param {Object} request.data - Dados da requisição, incluindo:
 *   @param {string} request.data.userId - UID do usuário cujo role será
 *                                         alterado.
 *   @param {string} request.data.role - Novo role a ser atribuído.
 * @param {Object} request.auth - Contexto de autenticação do usuário chamador.
 * @return {Promise<Object>} - Retorna um objeto com uma mensagem de sucesso.
 * @description
 * 1. Verifica se o chamador está autenticado e é admin.
 * 2. Atualiza o custom claim do usuário alvo com o novo role.
 *
 * @throws {Error} - Caso o chamador não esteja autenticado, não seja admin,
 *                   falte userId ou role na requisição, ou haja falha ao
 *                   definir o custom claim.
 */
exports.changeUserRole = onCall(
    {
      region: "southamerica-east1",
    },
    async (request) => {
      try {
        const context = request.auth;
        // Verificar se o usuário está autenticado
        if (!context) {
          throw new Error("User must be authenticated to call this function.");
        }

        // Verificar se o usuário é admin
        const currentUserClaims = context.token;
        if (!currentUserClaims.role || currentUserClaims.role !== "admin") {
          throw new Error(
              "Permission denied: only admin can change user roles");
        }

        // Extrair payload
        const {userId, role} = request.data;

        if (!userId || !role) {
          throw new Error("Missing userId or role parameter");
        }

        // Atualizar o role do usuário
        await auth.setCustomUserClaims(userId, {role});
        console.log(
            `Custom claims success => user: ${userId} role: ${role}`);

        return {
          message: `Custom claims success => user: ${userId} role: ${role}`,
        };
      } catch (error) {
        console.error("Error changing user role:", error);
        throw new Error("Failed to set custom claims");
      }
    });


// ==============================
// Módulos auxiliares
// ==============================
/**
 * Verifica se o usuário está autenticado no contexto da requisição.
 *
 * @function verifyAuth
 * @param {Object} request - Objeto da requisição do Firebase Functions
 *                           (onCall).
 * @param {Object} request.auth - Contexto de autenticação do usuário.
 * @return {string} - Retorna o UID do usuário autenticado.
 * @throws {HttpsError} - Caso não haja contexto de autenticação (usuário
 *                        não logado).
 */
function verifyAuth(request) {
  const auth = request.auth;
  if (!auth) {
    console.error("User is not authenticated.");
    throw new HttpsError(
        "unauthenticated",
        "User must be authenticated.",
    );
  }
  console.log("User verified");
  return auth.uid;
}


/**
 * Valida e retorna os itens enviados na requisição.
 *
 * @function validateItems
 * @param {Object} request - Objeto da requisição Firebase Functions (onCall).
 * @return {Array} - Lista de itens validados.
 * @throws {HttpsError} - Caso items não sejam encontrados ou não sejam um
 *                        array válido.
 */
function validateItems(request) {
  const items = request.data.items;

  if (!items || !Array.isArray(items)) {
    throw new HttpsError("invalid-argument", "Items must be an array.");
  }

  return items;
}


/**
 * Reserva os itens selecionados pelo usuário, decrementando a quantidade
 * em estoque e criando/atualizando um registro de reserva no Firestore.
 *
 * @async
 * @function reserveItems
 * @param {Array<Object>} items - Lista de itens, cada item contendo adId e
 *                                quantity.
 * @param {string} userId - UID do usuário que está fazendo a reserva.
 * @return {Promise<void>} - Completa quando a reserva estiver confirmada.
 * @throws {HttpsError} - Caso o item não exista, não haja estoque suficiente ou
 *                        o usuário não esteja autenticado.
 */
async function reserveItems(items, userId) {
  const batch = db.batch();
  const now = Date.now();
  const reservedUntil = now + 30 * 60 * 1000;

  for (const item of items) {
    const adRef = db.collection("ads").doc(item.adId);
    const reserveRef = adRef.collection("reserve").doc(userId);
    console.log(`userId: ${userId} -> adId: ${item.adId}`);

    const adDoc = await adRef.get();

    if (!adDoc.exists) {
      throw new HttpsError("not-found", `Item not found: ${item.adId}`);
    }

    const adData = adDoc.data();

    if (adData.quantity < item.quantity) {
      throw new HttpsError(
          "failed-precondition",
          `Not enough stock for item ${adData.title}.
           Available: ${adData.quantity}, Requested: ${item.quantity}`,
      );
    }

    // Verifica se existe uma reserva para este item neste userId
    const reservedItem = await reserveRef.get();
    if (reservedItem.exists) {
      // Verifica de a quantidade reservada corresponde a esta compra
      const reservedData = reservedItem.data();

      if (reservedData.quantity === item.quantity) {
        // Apenas altera o tempo de espiração da reserva
        console.log("Updating reservedUntil for existing reservation");
        batch.update(reserveRef, {reservedUntil: reservedUntil});
        continue;
      }

      // Corrige a quantidade da reserva e no estoque
      const quantityDiff = reservedData.quantity - item.quantity;

      console.log(
          `Adjusting reservation: ReservedQt=${reservedData.quantity},
          NewQt=${item.quantity}, Diff=${quantityDiff}`);

      // Corrige estoque do produto.
      const newQuantity = adData.quantity + quantityDiff;
      batch.update(adRef, {
        quantity: newQuantity,
        status: newQuantity === 0 ? "sold" : adData.status,
      });

      batch.set(reserveRef, {
        quantity: item.quantity,
        reservedUntil: reservedUntil,
      });
    } else {
      // Atualizar os campos: decrementar quantity e incrementar
      // reservedData.quantity
      console.log("Creating new reservation.");
      batch.update(adRef, {
        quantity: FieldValue.increment(-item.quantity),
        status: adData.quantity - item.quantity === 0 ? "sold" : adData.status,
      });

      // Criar sub-coleção de reserva de jogo
      batch.set(reserveRef, {
        quantity: item.quantity,
        reservedUntil: reservedUntil, // Expidação da reserva
      });
    }
  }

  // Commit do batch
  await batch.commit();
  console.log("Items reserved successfully.");
}


/**
 * Cria uma sessão de checkout no Stripe com base nos itens reservados.
 *
 * @async
 * @function createStripeSession
 * @param {Array} items - Lista de itens reservados para checkout, contendo
 *                        title e unit_price.
 * @param {string} userId - UID do usuário autenticado.
 * @return {Promise<string>} - Retorna a URL da sessão de checkout do Stripe.
 * @throws {HttpsError} - Caso a chave da API do Stripe não esteja configurada
 *                        ou haja falha na criação da sessão.
 */
async function createStripeSession(items, userId) {
  const now = Math.floor(Date.now() / 1000); // Tempo atual em segundos
  const expiresAt = now + 30 * 60; // 5 minutos em segundos
  const stripeApiKey = STRIPE_API_KEY.value();

  if (!stripeApiKey) {
    console.error("STRIPE_API_KEY is not defined.");
    throw new HttpsError("internal", "Stripe API key not configured.");
  }

  const stripeInstance = stripe(stripeApiKey);

  const lineItems = items.map((item) => ({
    price_data: {
      currency: "brl",
      product_data: {name: item.title},
      unit_amount: Math.round(item.unit_price * 100),
    },
    quantity: item.quantity,
  }));

  const session = await stripeInstance.checkout.sessions.create({
    payment_method_types: ["card", "boleto"],
    line_items: lineItems,
    mode: "payment",
    success_url: "https://rralves.dev.br/boards-pagamento-sucesso/",
    cancel_url: "https://rralves.dev.br/boards-pagamento-cancelado/",
    locale: "pt-BR",
    payment_method_options: {
      card: {
        installments: {enabled: true},
      },
    },
    metadata: {
      userId,
      items: JSON.stringify(items),
    },
    expires_at: expiresAt,
  });

  console.log("createStripeSession resolved");
  return session.url;
}

