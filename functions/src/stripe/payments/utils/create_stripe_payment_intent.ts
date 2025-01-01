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

// src/stripe/payments/utils/create_stripe_payment_intent.ts

import Stripe from "stripe";

import { PaymentData } from "../interfaces/payment_item";


/**
 * Cria um PaymentIntent no Stripe.
 *
 * @function createStripePaymentIntent
 * @param {Stripe} stripeInstance - Instância inicializada do Stripe.
 * @param {PaymentItem} params - Parâmetros para o
 *                                  PaymentIntent.
 * @return {Promise<Stripe.PaymentIntent>} Objeto do PaymentIntent criado.
 * @throws {Error} Caso `totalAmount`, `userId` ou `items` sejam inválidos.
 */
export async function createStripePaymentIntent(
  stripeInstance: Stripe,
  { totalAmount, userId, items }: PaymentData
): Promise<Stripe.PaymentIntent> {
  if (!totalAmount || !userId || !items || items.length === 0) {
    throw new Error("Missing or invalid parameters for creating PaymentIntent");
  }

  // Cria o PaymentIntent no Stripe
  return stripeInstance.paymentIntents.create({
    amount: totalAmount,
    payment_method_types: ["card"],
    description: "Compra de produtos",
    currency: "brl",
    metadata: {
      userId,
      items: JSON.stringify(items),
    },
  });
}
