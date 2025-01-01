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
