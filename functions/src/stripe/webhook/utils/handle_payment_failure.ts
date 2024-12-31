// src/stripe/webhook/utils/handle_payment_failure.ts

import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";

import { StripeSessionData } from "../interfaces/stripe_session_data";

/**
 * Restaura estoque e remove reservas quando o pagamento Stripe falha ou expira.
 *
 * @param {StripeSessionData} session - Objeto de sessão do Stripe, contendo
 *                            `metadata.items` (JSON) e `metadata.userId`.
 * @return {Promise<void>} - Resolve quando o estoque é restaurado e as
 *                            reservas removidas.
 * @throws {Error} Se `metadata`, `items` ou `userId` estiverem ausentes.
 */
export async function handlePaymentFailure(
  session: StripeSessionData,
): Promise<void> {
  const db = getFirestore();

  logger.info("Starting handlePaymentFailure...");

  const metadata = session.metadata;
  if (!metadata || !metadata.items || !metadata.userId) {
    logger.error("Metadata missing in session:", { sessionId: session.id });
    throw new Error("Session metadata is incomplete or missing.");
  }

  // items é um array de objetos { adId, quantity }
  const items = JSON.parse(metadata.items) as Array<{
    adId: string;
    quantity: number;
  }>;

  const userId = metadata.userId;
  const batch = db.batch();

  for (const item of items) {
    const adRef = db.collection("ads").doc(item.adId);
    const reserveRef = adRef.collection("reserve").doc(userId);

    // Restaura o estoque
    batch.update(adRef, {
      quantity: FieldValue.increment(item.quantity),
    });

    // Remove reserva
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
