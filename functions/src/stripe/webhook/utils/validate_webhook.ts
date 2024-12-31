// src/stripe/webhook/utils/validate_webhook.ts

import Stripe from "stripe";
import { logger } from "firebase-functions/v2";

/**
 * Valida o evento recebido do Stripe usando o webhook secret.
 *
 * @param {Buffer} rawBody - Corpo bruto da requisição (Buffer).
 * @param {string} signature - Assinatura recebida no cabeçalho
 *                             "stripe-signature".
 * @param {Stripe} stripeInstance - Instância do Stripe.
 * @param {string} webhookSecret - Chave secreta do webhook no Stripe.
 * @return {Stripe.Event} - O evento validado do Stripe.
 * @throws {Error} Se a validação do webhook falhar ou se rawBody estiver
 *                 inválido.
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
    const errorMessage = `Erro ao validar webhook: ${(error as Error).message}`;
    logger.error(errorMessage);
    throw new Error(errorMessage);
  }
}
