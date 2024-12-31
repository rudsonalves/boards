// src/boardgames/functions/sync_create_bg_bames.ts

import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { logger } from "firebase-functions/v2";
import { getFirestore } from "firebase-admin/firestore";

import { BoardgameData } from "../interfaces/boardgame_data";

/**
 * Sincroniza informações de boardgames para a coleção "bgnames".
 */
export const syncCreateBGNames = onDocumentCreated(
  {
    document: "boardgames/{boardgameId}",
    region: "southamerica-east1",
  },
  async (event) => {
    logger.info("Triggered syncCreateBGNames");

    const newValue = event.data?.data() as BoardgameData;
    const boardgameId = event.params?.boardgameId;

    // Validação dos campos necessários
    if (!newValue?.name || !newValue?.publishYear) {
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
      logger.error(`Error syncing boardgame ${boardgameId} to bgnames`, error);
    }

  }
);
