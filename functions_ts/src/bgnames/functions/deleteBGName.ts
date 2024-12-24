// src/bgnames/functions/deleteBGName.ts

import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import { getFirestore } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";

/**
 * Deleta o documento correspondente em "bgnames/{boardgameId}" ao apagar
 * um boardgame.
 *
 * @function deleteBGName
 * @param {object} event - Evento Firestore onDocumentDeleted.
 * @param {string} event.params.boardgameId - ID do boardgame deletado.
 * @description
 * Quando um boardgame é removido de "boardgames/{boardgameId}", esta função
 * busca o documento correspondente em "bgnames/{boardgameId}" e o deleta,
 * caso exista.
 */
export const deleteBGName = onDocumentDeleted(
  {
    document: "boardgames/{boardgameId}",
    region: "southamerica-east1",
  }, async (event) => {
    const firestore = getFirestore();
    const boardgameId = event.params.boardgameId;
    const bgNameRef = firestore.collection("bgnames").doc(boardgameId);

    logger.info(`Triggered deleteBGName for boardgameId: ${boardgameId}`);

    try {
      const bgNameSnap = await bgNameRef.get();

      if (bgNameSnap.exists) {
        await bgNameRef.delete();
        logger.info(
          `Successfully deleted boardgame ${boardgameId} from bgnames`);
      } else {
        logger.info(
          `No corresponding bgnames document for boardgame ${boardgameId}`);
      }
    } catch (error) {
      logger.error(
        `Error deleting boardgame ${boardgameId} from bgnames`, error);
    }
  }
);
