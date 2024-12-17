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

// Inicializar o Firebase Admin SDK
admin.initializeApp();
const firestore = admin.firestore();
const auth = admin.auth();
const db = admin.firestore();

// =====================
// Funções do Stripe
// =====================
//
exports.createCheckoutSession = onCall(
    {
      region: "southamerica-east1",
      secrets: ["STRIPE_SECRET_KEY"],
    },
    async (request) => {
      try {
        // 1. Verificar autenticação do usuário
        const userId = verifyAuth(request);

        // 2. Validar os itens
        const items = request.data.items;
        validateItems(items);

        // 3. Reservar os itens
        await reserveItems(items, userId);

        // 4. Criar sessão no Stripe
        const sessionUrl = await createStripeSession(items, userId);

        return {url: sessionUrl};
      } catch (error) {
        console.error("Error in createCheckoutSession:", error);
        throw new HttpsError("internal", error.message);
      }
    });

// Função de Payment Intent do Stripe
exports.createPaymentIntent = onCall(
    {
      region: "southamerica-east1",
      secrets: ["STRIPE_SECRET_KEY"],
    },
    async (request) => {
      try {
        // Inicie o Stripe usando a secret do ambiente
        const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);

        // Verificar autenticação do usuário
        const userId = verifyAuth(request);

        // Verificar se os itens foram enviados
        // console.log("Received request data:", request.data);
        const items = request.data.items;
        if (!items || !Array.isArray(items)) {
          console.error("Items are required and must be an array.");
          throw new HttpsError(
              "invalid-argument",
              "Items are required and must be an array.",
          );
        }

        // Calcular o valor total
        const totalAmount = items.reduce((total, item) => {
          return total + Math.round(item.unit_price * 100) * item.quantity;
        }, 0);

        // Criar o PaymentIntent
        const paymentIntent = await stripe.paymentIntents.create({
          amount: totalAmount,
          payment_method_types: ["card"],
          description: "Compra de produtos",
          currency: "brl",
          metadata: {
            userId,
            items: JSON.stringify(items),
          },
        });

        return {clientSecret: paymentIntent.client_secret};
      } catch (error) {
        console.error("Error in createPaymentIntent:", error);
        throw new HttpsError("internal", error.message);
      }
    });


// Função Stripe Webhook do Stripe
exports.stripeWebhook = onRequest(
    {
      region: "southamerica-east1",
      // Substitua pelo nome da secret definida previamente
      secrets: ["STRIPE_API_KEY"],
      cors: true,
      maxInstances: 1,
    },
    async (req, res) => {
      // Secret do Webhook obtido do Stripe
      const endpointSecret = "whsec_oi60ZJjCdRISxMVGInrSvyiulZ8DRCsM";
      const sig = req.headers["stripe-signature"];

      try {
        // Inicializa o Stripe usando a secret injetada
        const stripe = require("stripe")(process.env.STRIPE_API_KEY);

        // Valida a requisição do webhook
        const event = stripe.webhooks.constructEvent(
            req.rawBody,
            sig,
            endpointSecret,
        );

        // Tratamento dos eventos recebidos do webhook
        switch (event.type) {
          case "checkout.session.completed": {
            const session = event.data.object;
            await handlePaymentSuccess(session);
            break;
          }

          case "checkout.session.expired":
          case "checkout.session.async_payment_failed": {
            const session = event.data.object;
            await handlePaymentFailure(session);
            break;
          }

          default: {
            console.log(`Evento não tratado: ${event.type}`);
            break;
          }
        }

        res.status(200).send("Webhook processado com sucesso");
      } catch (err) {
        console.error("Falha na verificação da assinatura:", err.message);
        res.status(400).send(`Erro no Webhook: ${err.message}`);
      }
    });

// ==============================
// Funções auxiliares do Webhook
// ==============================

/**
 * Lida com o sucesso do pagamento.
 * @param {Object} session - Objeto da sessão do Stripe.
 */
async function handlePaymentSuccess(session) {
  const metadata = session.metadata;
  const items = JSON.parse(metadata.items);
  const userId = metadata.userId;

  const batch = db.batch();
  for (const item of items) {
    const adRef = db.collection("ads").doc(item.adId);
    const reserveRef = adRef.collection("reserve").doc(userId);

    // Remove a reserva ao confirmar a venda
    batch.delete(reserveRef);
  }

  await batch.commit();
  console.log(`Payment confirmed and reservations cleared for user: ${userId}`);
}

/**
 * Lida com o cancelamento ou falha do pagamento.
 * @param {Object} session - Objeto da sessão do Stripe.
 */
async function handlePaymentFailure(session) {
  const metadata = session.metadata;
  const items = JSON.parse(metadata.items);
  const userId = metadata.userId;

  const batch = db.batch();
  for (const item of items) {
    const adRef = db.collection("ads").doc(item.adId);
    const reserveRef = adRef.collection("reserve").doc(userId);

    const adDoc = await adRef.get();
    const adData = adDoc.data();

    // Restaurar a quantidade e remover reserva
    batch.update(adRef, {
      quantity: adData.quantity + item.quantity,
    });
    batch.delete(reserveRef);
  }

  await batch.commit();
  console.log(`Payment failed/canceled. Stock restored for user: ${userId}`);
}

// ===================================
// Funções Relacionadas a Boardgames
// ===================================

// Função para notificar usuários alvo de mensagem
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

// Função para sincronizar boardgames com bgnames na criação
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


// Função para deletar bgnames quando um boardgame é deletado
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

// Função assignDefaultUserRole
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

// Função changeUserRole
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
 * Verifica se o usuário está autenticado e retorna seu UID.
 *
 * @param {object} request - O objeto da requisição do Firebase Functions.
 * @param {object} request.auth - O contexto de autenticação do Firebase.
 * @return {string} - O UID do usuário autenticado.
 * @throws {HttpsError} - Lança erro caso o usuário não esteja autenticado.
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
 * Valida a estrutura dos itens recebidos na requisição.
 *
 * @param {Array} items - Lista de itens a serem validados.
 * @throws {HttpsError} - Lança erro caso os itens sejam inválidos ou não
 *      sejam um array.
 */
function validateItems(items) {
  if (!items || !Array.isArray(items)) {
    throw new HttpsError("invalid-argument", "Items must be an array.");
  }
  console.log("Validated Items");
}

/**
 * Reserva os itens selecionados pelo usuário, atualizando a quantidade
 * disponível no anúncio e criando um registro de reserva em uma sub-coleção.
 *
 * @param {Array<Object>} items - Lista de itens a serem reservados. Cada item
 * deve conter:
 *   @param {string} items[].adId - ID do anúncio (documento) no Firestore.
 *   @param {number} items[].quantity - Quantidade do item a ser reservada. Deve
 *      ser maior que zero.
 * @param {string} userId - ID do usuário que está efetuando a reserva.
 * @return {Promise<void>} - Retorna uma Promise que é resolvida após a reserva
 *      ser concluída.
 * @throws {HttpsError} - Lança erro se:
 *   - `item.quantity` for menor ou igual a zero.
 *   - O documento do anúncio não existir.
 *   - Não houver estoque suficiente para a quantidade solicitada.
 */
async function reserveItems(items, userId) {
  const batch = db.batch();

  for (const item of items) {
    if (item.quantity <= 0) {
      throw new HttpsError(
          "invalid-argument",
          "Quantity must be greater than zero.",
      );
    }

    const adRef = db.collection("ads").doc(item.adId);
    console.log(`userId: ${userId} -> adId: ${item.adId}`);
    const reserveRef = adRef.collection("reserve").doc(userId);

    const adDoc = await adRef.get();

    if (!adDoc.exists) {
      throw new HttpsError("not-found", `Item not found: ${item.adId}`);
    }

    const adData = adDoc.data();
    let adquantity = adData.quantity;

    if (adquantity < item.quantity) {
      throw new HttpsError(
          "failed-precondition",
          `Not enough stock for item ${adData.title}.
           Available: ${adData.quantity}, Requested: ${item.quantity}`,
      );
    }

    // Atualizar os campos: decrementar quantity e incrementar reservedQt
    adquantity -= item.quantity;
    batch.update(adRef, {
      quantity: adquantity,
      status: adquantity === 0 ? "sold" : adData.status,
    });

    // Criar sub-coleção de reserva de jogo
    batch.set(reserveRef, {
      quantity: item.quantity,
    });
  }

  // Commit do batch
  await batch.commit();
  console.log("Items reserved successfully.");
}

/**
 * Cria uma sessão de pagamento no Stripe usando os itens reservados.
 *
 * @param {Array} items - Lista de itens reservados para checkout.
 * @param {string} userId - ID do usuário autenticado.
 * @return {Promise<string>} - URL da sessão de checkout do Stripe.
 * @throws {Error} - Lança erro caso ocorra falha ao criar a sessão no Stripe.
 */
async function createStripeSession(items, userId) {
  const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);

  const lineItems = items.map((item) => ({
    price_data: {
      currency: "brl",
      product_data: {name: item.title},
      unit_amount: Math.round(item.unit_price * 100),
    },
    quantity: item.quantity,
  }));

  const session = await stripe.checkout.sessions.create({
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
  });

  console.log("createStripeSession resolved");
  return session.url;
}

