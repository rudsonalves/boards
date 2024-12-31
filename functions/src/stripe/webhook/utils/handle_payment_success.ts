// src/stripe/webhook/utils/handle_payment_success.ts

import { logger } from "firebase-functions/v2";
import { getFirestore } from "firebase-admin/firestore";

import { StripeSessionData } from "../interfaces/stripe_session_data";

/**
 * Remove reservas de itens comprados quando o pagamento Stripe é bem-sucedido.
 *
 * @param {StripeSessionData} session - Objeto de sessão do Stripe, contendo
 *                          `metadata.items` (JSON) e `metadata.userId`.
 * @return {Promise<void>} - Resolve quando as reservas são removidas.
 * @throws {Error} Se `metadata`, `items` ou `userId` estiverem ausentes.
 */
export async function handlePaymentSuccess(
  session: StripeSessionData,
): Promise<void> {
  const db = getFirestore();

  logger.info("Starting handlePaymentSuccess...");

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
    const reserveRef = db
      .collection("ads")
      .doc(item.adId)
      .collection("reserve")
      .doc(userId);

    // Remove a reserva ao confirmar pagamento
    batch.delete(reserveRef);

    logger.info("Reservation removed for item", {
      userId,
      adId: item.adId,
    });
  }

  await batch.commit();
  logger.info("Payment confirmed and reservations cleared", { userId });
}
