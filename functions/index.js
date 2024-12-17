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
        // Inicie o Stripe usando a secret do ambiente
        const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);

        // Verificar autenticação do usuário
        const auth = request.auth;
        if (!auth) {
          console.error("User is not authenticated.");
          throw new HttpsError(
              "unauthenticated",
              "User must be authenticated.",
          );
        }

        const userId = auth.uid;
        console.log(`Authenticated user ID: ${userId}`);

        const items = request.data.items;
        if (!items || !Array.isArray(items)) {
          console.error("Items are required and must be an array.");
          throw new HttpsError("invalid-argument", "Items must be an array.");
        }

        // Calcular o valor total
        const lineItems = items.map((item) => ({
          price_data: {
            currency: "brl",
            product_data: {
              name: item.title,
            },
            unit_amount: Math.round(item.unit_price * 100),
          },
          quantity: item.quantity,
        }));

        // Criar a sessão de checkout
        const session = await stripe.checkout.sessions.create({
          payment_method_types: ["card", "boleto"],
          line_items: lineItems,
          mode: "payment",
          // substitua pela URL do seu site/app
          success_url: "https://rralves.dev.br/boards-pagamento-sucesso/",
          // substitua pela URL do seu site/app
          cancel_url: "https://rralves.dev.br/boards-pagamento-cancelado/",
          locale: "pt-BR",
          metadata: {
            userId,
            items: JSON.stringify(items),
          },
        });

        return {url: session.url};
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

        console.log("Function createPaymentIntent called.");

        // Verificar autenticação do usuário
        const auth = request.auth;
        if (!auth) {
          console.error("User is not authenticated.");
          throw new HttpsError(
              "unauthenticated",
              "User must be authenticated to call this function.",
          );
        }

        const userId = auth.uid;
        console.log(`Authenticated user ID: ${userId}`);

        // Verificar se os itens foram enviados
        console.log("Received request data:", request.data);
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

        console.log("PaymentIntent created successfully:", {
          clientSecret: paymentIntent.client_secret,
          totalAmount,
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
          case "payment_intent.succeeded": {
            const paymentIntent = event.data.object;
            console.log("Pagamento bem-sucedido:", paymentIntent);
            // Aqui você pode atualizar o Firestore, enviar notificações etc.
            break;
          }

          case "payment_intent.payment_failed": {
            const failedIntent = event.data.object;
            console.error("Pagamento falhou:", failedIntent);
            // Notifique o cliente, registre logs, etc.
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

// =====================
// Funções Relacionadas a Boardgames
// =====================

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

