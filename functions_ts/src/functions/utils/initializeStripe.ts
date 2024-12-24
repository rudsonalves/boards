// src/functions/utils/initializeStripe.ts

import Stripe from "stripe";

/**
 * Inicializa a instância do Stripe usando as chaves de API apropriadas.
 *
 * @function initializeStripe
 * @return {Stripe} - Instância do Stripe.
 * @throws {Error} - Caso a chave da API do Stripe não esteja configurada.
 */
export function initializeStripe(): Stripe {
  const stripeApiKey = process.env.STRIPE_API_KEY;

  if (!stripeApiKey) {
    const message = "Stripe API key not configured.";
    console.error(message);
    throw new Error(message);
  }

  return new Stripe(stripeApiKey);
}
