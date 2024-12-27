// src/webhook/utils/processStripeEvent.ts

import { Stripe } from "stripe";
import { handlePaymentSuccess } from "./handlePaymentSuccess";
import { handlePaymentFailure } from "./handlePaymentFailure";

/**
 * Processes the Stripe event based on its type.
 *
 * @async
 * @function processStripeEvent
 * @param {Stripe.Event} event - Validated Stripe event object.
 */
export async function processStripeEvent(
  event: Stripe.Event,
): Promise<void> {
  switch (event.type) {
    case "checkout.session.completed": {
      const session = event.data.object as Stripe.Checkout.Session;
      await handlePaymentSuccess(session);
      console.log(`Processed Stripe event: ${event.type}`);
      break;
    }

    case "checkout.session.expired":
    case "checkout.session.async_payment_failed": {
      const session = event.data.object as Stripe.Checkout.Session;
      await handlePaymentFailure(session);
      console.log(`Processed payment failure event: ${event.type}`);
      break;
    }

    default: {
      console.log(`Unhandled Stripe event type: ${event.type}`);
      break;
    }
  }
}
