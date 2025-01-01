// Copyright (C) 2025 Rudson Alves
//
// This file is part of boards.
//
// boards is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// boards is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with boards.  If not, see <https://www.gnu.org/licenses/>.

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
