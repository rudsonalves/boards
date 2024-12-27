// src/webhook/utils/handlePaymentFailure.ts

import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";

/**
 * Handles payment failures or Stripe checkout expiration by restoring item
 * stock and removing reservations.
 *
 * @async
 * @function handlePaymentFailure
 * @param {object} session - Stripe session object (checkout.session).
 * @throws {Error} If metadata or items are missing in the session.
 */
export async function handlePaymentFailure(session: {
  id: string;
  metadata?: { items?: string; userId?: string } | null;
}): Promise<void> {
  const db = getFirestore();

  logger.info("Starting handlePaymentFailure...");

  const metadata = session.metadata;
  if (!metadata || !metadata.items || !metadata.userId) {
    logger.error("Missing metadata in session:", { sessionId: session.id });
    throw new Error("Session metadata is incomplete or missing.");
  }

  const items = JSON.parse(metadata.items) as Array<{
    adId: string;
    quantity: number;
  }>;

  const userId = metadata.userId;
  const batch = db.batch();

  for (const item of items) {
    const adRef = db.collection("ads").doc(item.adId);
    const reserveRef = adRef.collection("reserve").doc(userId);

    // Restore stock quantity
    batch.update(adRef, {
      quantity: FieldValue.increment(item.quantity),
    });

    // Remove reservation
    batch.delete(reserveRef);

    logger.info("Stock restored for item", {
      userId,
      adId: item.adId,
      quantity: item.quantity,
    });
  }

  await batch.commit();
  logger.info("Stock and reservations updated successfully", { userId });
}
