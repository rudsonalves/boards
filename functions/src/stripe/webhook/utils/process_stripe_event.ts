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
