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

// src/stripe/webhook/functions/stripe_webhook.ts

import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { IncomingMessage, ServerResponse } from "http";

import { initializeStripe } from "../../utils/initialize_stripe";
import Stripe from "stripe";
import { processStripeEvent } from "../utils/process_stripe_event";

/**
 * Função HTTP que lida com webhooks do Stripe.
 * Lê a requisição (como Node.js puro), valida a assinatura, e processa o
 * evento.
 *
 * @param {IncomingMessage} request - Requisição HTTP fornecida pelo Firebase.
 * @param {ServerResponse} response - Objeto de resposta para o cliente
 *                                    (Stripe).
 * @param response - Objeto de resposta HTTP para enviar o resultado ao Stripe.
 **/
export const stripeWebhook = onRequest(
  {
    region: "southamerica-east1",
    maxInstances: 1,
    secrets: ["WEBHOOK_SEC", "STRIPE_API_KEY"],
  },
  async (request: IncomingMessage, response: ServerResponse) => {
    try {
      logger.info("Iniciando stripeWebhook");

      // Acessando os segredos via process.env
      const webhookSecret = process.env.WEBHOOK_SEC;
      const stripeApiKey = process.env.STRIPE_API_KEY;

      if (!stripeApiKey || !webhookSecret) {
        const errorMessage = "Configuração do Stripe incompleta.";
        logger.error(errorMessage);
        response.statusCode = 500;
        response.end(errorMessage);
        return;
      }

      const stripeInstance = initializeStripe(stripeApiKey);
      const isStripe = stripeInstance instanceof Stripe;
      if (!isStripe) {
        const errorMessage = "stripeInstance nõ é uma instância de Stripe.";
        logger.error(errorMessage);
        response.statusCode = 500;
        response.end(errorMessage);
        return;
      }
      logger.info(`Instância do Stripe inicializada: ${isStripe}`);

      // Resposta inicial ao Stripe
      response.statusCode = 200;
      response.end("Webhook recebido.");

      // Obter o corpo bruto da requisição
      const rawBody = (request as any).rawBody;

      const signatureHeader = request.headers["stripe-signature"];
      if (!signatureHeader) {
        const errorMessage = "Cabeçalho stripe-signature ausente.";
        logger.error(errorMessage);
        response.statusCode = 400;
        response.end(errorMessage);
        return;
      }

      // Validar e construir o evento
      let event;
      try {
        event = stripeInstance.webhooks.constructEvent(
          rawBody,
          signatureHeader,
          webhookSecret
        );
      } catch (err) {
        const errorMessage =
          `Erro ao validar webhook: ${(err as Error).message}`;
        logger.error(errorMessage);
        response.statusCode = 400;
        response.end(errorMessage);
        return;
      }

      logger.info(`Evento Stripe validado: ${event.type}`);

      // Processar o evento Stripe
      try {
        await processStripeEvent(event);
      } catch (err) {
        logger.error(
          `Erro ao processar evento Stripe: ${(err as Error).message}`);
      }
    } catch (error) {
      const errorMessage = `Erro inesperado: ${(error as Error).message}`;
      logger.error(errorMessage);
      response.statusCode = 500;
      response.end(errorMessage);
    }
  }
);
