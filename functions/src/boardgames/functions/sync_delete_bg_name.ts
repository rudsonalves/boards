// src/boardgames/functions/sync_delete_bg_name.ts

import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import { logger } from "firebase-functions/v2";
import { getFirestore } from "firebase-admin/firestore";

/**
 * Sincroniza informações de boardgames para a coleção "bgnames".
 */
export const syncDeleteBGName = onDocumentDeleted(
  {
    document: "boardgames/{boardgameId}",
    region: "southamerica-east1",
  },
  async (event) => {
    logger.info("Triggered syncDeleteBGName");

    const boardgameId = event.params?.boardgameId;
    if (!boardgameId) {
      logger.error("Boardgame ID is missing in event parameters.");
      return;
    }

    const firestore = getFirestore();
    const bgNameRef = firestore.collection("bgnames").doc(boardgameId);

    try {
      const bgNamesSnap = await bgNameRef.get();
      if (bgNamesSnap.exists) {
        await bgNameRef.delete();
        logger.info(
          `Successfully deleted boardgame ${boardgameId} from bgnames`
        );
      } else {
        logger.info(
          `No corresponding bgnames document for boardgame ${boardgameId}`
        );
      }
    } catch (error) {
      logger.error(
        `Error deleting boardgame ${boardgameId} from bgnames`,
        error,
      );
    }
  }
);
