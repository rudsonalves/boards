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

// src/stripe/webhook/utils/handle_payment_failure.ts

import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";
import Stripe from "stripe";

import { COLLECTIONS } from "../../../utils/collections";
import { ADSTATUS } from "../../../utils/ad_status";
import { IItem } from "../../payments/interfaces/payment_item";


/**
 * Restaura estoque e remove reservas quando o pagamento Stripe falha ou
 * expira.
 *
 * @param {Stripe.Checkout.Session} session - Objeto de sessão do Stripe,
 *                      contendo `metadata.items` (JSON) e `metadata.userId`.
 * @return {Promise<void>} - Resolve quando o estoque é restaurado e as
 *                           reservas removidas.
 * @throws {Error} Se `metadata`, `items` ou `userId` estiverem ausentes.
 */
export async function handlePaymentFailure(
  session: Stripe.Checkout.Session,
): Promise<void> {
  const db = getFirestore();

  logger.info("Starting handlePaymentFailure...");

  const metadata = session.metadata;
  if (!metadata || !metadata.items || !metadata.userId) {
    logger.error("Metadata missing in session:", { sessionId: session.id });
    throw new Error("Session metadata is incomplete or missing.");
  }

  // items é um array de objetos { adId, quantity }
  const items = JSON.parse(metadata.items) as IItem[];

  const userId = metadata.userId;
  const batch = db.batch();

  for (const item of items) {
    const adRef = db
      .collection(COLLECTIONS.ADS)
      .doc(item.adId);
    const reserveRef = adRef
      .collection(COLLECTIONS.RESERVE)
      .doc(userId);

    // Remove reserva
    batch.delete(reserveRef);

    logger.info("Stock restored for item", {
      userId,
      adId: item.adId,
      quantity: item.quantity,
    });

    // atualiza ad status e estoque
    const adGet = await adRef.get();
    if (adGet.exists) {
      batch.update(adRef, {
        quantity: FieldValue.increment(item.quantity),
        status: ADSTATUS.ACTIVE,
      });
      logger.info("Stock restored and status updated to 'active'.", {
        adId: item.adId,
        restoredQuantity: item.quantity,
        status: ADSTATUS.ACTIVE,
      });
    } else {
      logger.warn("Ad document does not exist", { adId: item.adId });
    }
  }

  await batch.commit();
  logger.info("Stock and reservations updated successfully", { userId });
}
