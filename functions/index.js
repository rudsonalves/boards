// Importações necessárias
const {onDocumentCreated, onDocumentDeleted} =
    require("firebase-functions/v2/firestore");
const {onRequest} = require("firebase-functions/v2/https");
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
    "boardgames/{boardgameId}", async (event) => {
      const newValue = event.data;
      const boardgameId = event.params.boardgameId;

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
            `Successfully synced boardgame ${boardgameId} to bgnames`,
        );
      } catch (error) {
        console.error(
            `Error syncing boardgame ${boardgameId} to bgnames`,
            error);
      }
    });

// Função para deletar bgnames quando um boardgame é deletado
exports.deleteBGName = onDocumentDeleted(
    "boardgames/{boardgameId}", async (event) => {
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
// Funções Migradas do Go para JavaScript
// =====================

// Função AssignDefaultUserRole
exports.AssignDefaultUserRole = onRequest(async (req, res) => {
  try {
    // Verificar token de autenticação
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).send("Missing or invalid Authorization header");
    }

    const idToken = authHeader.split("Bearer ")[1];
    const decodedToken = await auth.verifyIdToken(idToken);
    const userId = decodedToken.uid;

    if (!userId) {
      return res.status(400).send("Could not extract user ID from token");
    }

    // Definir o role como "user"
    const role = "user";

    // Se for a primeira configuração, descomente a linha abaixo para
    // definir como "admin"
    // const role = "admin";

    await auth.setCustomUserClaims(userId, {role});
    console.log(
        `Custom claims successfully => user: ${userId} role: ${role}`,
    );

    return res.status(200).json({
      result:
          `Custom claims successfully => user: ${userId} role: ${role}`,
    });
  } catch (error) {
    console.error("Error assigning default user role:", error);
    return res.status(500).send("Failed to set custom claims");
  }
});

// Função ChangeUserRole
exports.ChangeUserRole = onRequest(async (req, res) => {
  try {
    // Verificar token de autenticação
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).send("Missing or invalid Authorization header");
    }

    const idToken = authHeader.split("Bearer ")[1];
    const decodedToken = await auth.verifyIdToken(idToken);

    // Verificar se o usuário é admin
    if (!decodedToken.role || decodedToken.role !== "admin") {
      return res.status(403).send(
          "Permission denied: only admin can change user roles");
    }

    // Extrair payload
    const {userId, role} = req.body.data;

    if (!userId || !role) {
      return res.status(400).send("Missing userId or role parameter");
    }

    // Atualizar o role do usuário
    await auth.setCustomUserClaims(userId, {role});
    console.log(
        `Custom claims successfully => user: ${userId} role: ${role}`);

    return res.status(200).json({
      result: `Custom claims successfully => user: ${userId} role: ${role}`,
    });
  } catch (error) {
    console.error("Error changing user role:", error);
    return res.status(500).send("Failed to set custom claims");
  }
});

