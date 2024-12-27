// src/stripe/utils/initializeStripe.ts

import Stripe from "stripe";

/**
 * Inicializa a instância do Stripe usando as chaves de API apropriadas.
 *
 * @function initializeStripe
 * @param {string} stripeApiKey - Chave de API do Stripe.
 * @return {Stripe} - Instância do Stripe.
 * @throws {Error} - Caso a chave da API do Stripe não esteja configurada.
 */
export function initializeStripe(stripeApiKey: string): Stripe {
  if (!stripeApiKey) {
    const message = "Stripe API key not configured.";
    console.error(message);
    throw new Error(message);
  }

  return new Stripe(stripeApiKey);
}
