const {onDocumentUpdated} = require("firebase-functions/v2/firestore");
const {getFirestore} = require("firebase-admin/firestore");
const {logger} = require("firebase-functions/v2");

const firestore = getFirestore();

/**
 * Sincroniza informações de boardgames para a coleção "bgnames".
 */
exports.syncUpdateBGNames = onDocumentUpdated(
    {
      document: "boardgames/{boardgameId}",
      region: "southamerica-east1",
    },
    async (event) => {
      const boardgameId = event.params.boardgameId;
      const newValue = event.data.before;

      logger.info(
          `Triggered syncUpdateBGNames for boardgameId: ${boardgameId}`,
      );
      logger.info("Document data received:", newValue);

      // Validação dos campos necessários
      if (!newValue.name || !newValue.publishYear) {
        logger.error(`Missing fields in boardgame ${boardgameId}`);
        return;
      }

      const bgNameDoc = {
        name: `${newValue.name} (${newValue.publishYear})`,
        publishYear: newValue.publishYear,
      };

      try {
        await firestore.collection("bgnames").doc(boardgameId).set(bgNameDoc);
        logger.info(
            `Successfully synced boardgame ${boardgameId} to bgnames`,
        );
      } catch (error) {
        logger.error(
            `Error syncing boardgame ${boardgameId} to bgnames`,
            error,
        );
      }
    },
);
