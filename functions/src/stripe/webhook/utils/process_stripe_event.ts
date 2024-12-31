// src/stripe/webhook/utils/process_stripe_event.ts

import { Stripe } from "stripe";
import { logger } from "firebase-functions/v2";

import { handlePaymentSuccess } from "./handle_payment_success";
import { handlePaymentFailure } from "./handle_payment_failure";

/**
 * Processa o evento do Stripe com base no tipo.
 *
 * @param {Stripe.Event} event - Evento validado do Stripe.
 * @return {Promise<void>} - Resolve ao final do processamento do evento.
 */
export async function processStripeEvent(
  event: Stripe.Event,
): Promise<void> {
  switch (event.type) {
  case "checkout.session.completed": {
    const session = event.data.object as Stripe.Checkout.Session;
    await handlePaymentSuccess(session);
    logger.info(`Processed Stripe event: ${event.type}`);
    break;
  }

  case "checkout.session.expired":
  case "checkout.session.async_payment_failed": {
    const session = event.data.object as Stripe.Checkout.Session;
    await handlePaymentFailure(session);
    logger.info(`Processed payment failure event: ${event.type}`);
    break;
  }

  default: {
    logger.info(`Unhandled Stripe event type: ${event.type}`);
    break;
  }
  }
}
