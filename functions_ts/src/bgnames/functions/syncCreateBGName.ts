// src/bgnames/functions/syncCreateBGName.ts

import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { getFirestore } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";

/**
 * Sincroniza um documento recém-criado em "boardgames/{boardgameId}"
 * com a coleção "bgnames", criando ou atualizando o documento correspondente.
 *
 * @param event - Evento Firestore onDocumentCreated.
 */
export const syncCreateBGName = onDocumentCreated(
  {
    document: "boardgames/{boardgameId}",
    region: "southamerica-east1",
  },
  async (event) => {
    const firestore = getFirestore();
    const newValue = event.data?.data();
    const boardgameId = event.params.boardgameId;

    logger.info(
      `Triggered syncCreateBGName for boardgameId: ${boardgameId}`
    );

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
      await firestore.collection("bgnames").doc(boardgameId).set(bgNameDoc);
      logger.info(
        `Successfully synced boardgame ${boardgameId} to bgnames`
      );
    } catch (error) {
      logger.error(
        `Error syncing boardgame ${boardgameId} to bgnames`,
        error
      );
    }
  }
);
