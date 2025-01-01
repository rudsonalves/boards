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
