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
