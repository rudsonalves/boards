// src/boardgames/functions/syncUpdateBGNames.ts

import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { logger } from "firebase-functions/v2";
import { getFirestore } from "firebase-admin/firestore";

import { BoardgameData } from "../interfaces/BoardgameData";

/**
 * Sincroniza informações de boardgames para a coleção "bgnames".
 */
export const syncUpdateBGNames = onDocumentUpdated(
  {
    document: "boardgames/{boardgameId}",
    region: "southamerica-east1",
  },
  async (event) => {
    logger.info("Triggered syncUpdateBGNames");

    const boardgameId = event.params?.boardgameId;
    if (!boardgameId) {
      logger.error("Boardgame ID is missing in event parameters.");
      return;
    }

    const newValue = event.data?.after?.data() as BoardgameData | undefined;
    // Validação dos campos necessários
    if (!newValue?.name || !newValue?.publishYear) {
      logger.error(`Missing fields in boardgame ${boardgameId}`);
      return;
    }

    // Validação dos campos necessários
    if (!newValue?.name || !newValue.publishYear) {
      logger.error(`Missing fields in boardgame ${boardgameId}`);
      return;
    }

    const bgNameDoc = {
      name: `${newValue.name} (${newValue.publishYear})`,
      publishYear: newValue.publishYear,
    };

    try {
      const firestore = getFirestore();
      await firestore.collection("bgnames").doc(boardgameId).set(bgNameDoc);
      logger.info(`Successfully synced boardgame ${boardgameId} to bgnames`);
    } catch (error) {
      logger.error(
        `Error syncing boardgame ${boardgameId} to bgnames`,
        error
      );
    }
  }
);
