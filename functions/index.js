// Configurações para conectar ao emulador
if (process.env.FUNCTIONS_EMULATOR === "true") {
  process.env.FIRESTORE_EMULATOR_HOST = "127.0.0.1:8080";
  process.env.FIREBASE_AUTH_EMULATOR_HOST = "127.0.0.1:9099";
}

// Importações necessárias
const {onDocumentCreated, onDocumentDeleted} =
    require("firebase-functions/v2/firestore");
const {onCall} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

// Inicializar o Firebase Admin SDK
admin.initializeApp();
const firestore = admin.firestore();
const auth = admin.auth();

// =====================
// Funções Relacionadas a Boardgames
// =====================

// Função para sincronizar boardgames com bgnames na criação
exports.syncBoardgameToBGNames = onDocumentCreated(
    {
      document: "boardgames/{boardgameId}",
      region: "southamerica-east1", // Define a região explicitamente
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
      region: "southamerica-east1", // Define a região explicitamente
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

