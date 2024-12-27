// src/webhook/utils/handlePaymentSuccess.ts

import { logger } from "firebase-functions/v2";
import { getFirestore } from "firebase-admin/firestore";

/**
 * Handles successful payment events from Stripe by removing item reservations.
 *
 * @async
 * @function handlePaymentSuccess
 * @param {object} session - Stripe session object (checkout.session).
 * @description
 * Extracts userId and items from the session metadata and removes corresponding
 * reservations from Firestore, confirming the purchase of the items.
 * @throws {Error} If metadata or items are missing in the session.
 */
export async function handlePaymentSuccess(session: {
  id: string;
  metadata?: { items?: string; userId?: string } | null;
}): Promise<void> {
  const db = getFirestore();

  logger.info("Starting handlePaymentSuccess...");

  const metadata = session.metadata;
  if (!metadata || !metadata.items || !metadata.userId) {
    logger.error("Metadata missing in session:", { sessionId: session.id });
    throw new Error("Session metadata is incomplete or missing.");
  }

  const items = JSON.parse(metadata.items) as Array<{
    adId: string;
    quantity: number;
  }>;
  const userId = metadata.userId;

  const batch = db.batch();

  for (const item of items) {
    const reserveRef = db
      .collection("ads")
      .doc(item.adId)
      .collection("reserve")
      .doc(userId);

    // Remove the reservation upon payment confirmation
    batch.delete(reserveRef);

    logger.info("Reservation removed for item", {
      userId,
      adId: item.adId,
    });
  }

  await batch.commit();
  logger.info("Payment confirmed and reservations cleared", { userId });
}
