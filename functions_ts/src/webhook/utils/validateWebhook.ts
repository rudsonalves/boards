// src/webhook/utils/validateWebhook.ts

import Stripe from "stripe";
import { logger } from "firebase-functions/v2";

/**
 * Valida o evento recebido do Stripe usando o webhook secret.
 *
 * @param {Buffer} rawBody - string,
 * @param {string} signature - string,
 * @param {Stripe} stripeInstance - Instância do Stripe.
 * @param {string} webhookSecret - wdbhook secret key.
 * @return {Stripe.Event} - Evento validado do Stripe.
 * @throws {Error} - Caso o segredo do webhook esteja ausente ou a validação
 *                   falhe.
 */
export function validateWebhook(
  rawBody: Buffer,
  signature: string,
  stripeInstance: Stripe,
  webhookSecret: string
): Stripe.Event {
  try {
    return stripeInstance.webhooks.constructEvent(
      rawBody,
      signature,
      webhookSecret,
    );
  } catch (error) {
    const errorMessage = "Erro ao validar webhook: " +
      `${(error as Error).message}`;
    logger.error(errorMessage);
    throw new Error(errorMessage);
  }
}
