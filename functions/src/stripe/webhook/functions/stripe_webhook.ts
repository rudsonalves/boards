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
      logger.info("Cabeçalhos:", JSON.stringify(request.headers));

      // Acessando os segredos via process.env
      const webhookSecret = process.env.WEBHOOK_SEC;
      const stripeApiKey = process.env.STRIPE_API_KEY;

      if (!stripeApiKey) {
        const errorMessage = "Chave de API do Stripe não está configurada.";
        logger.error(errorMessage);
        response.statusCode = 500;
        response.end(errorMessage);
        return;
      }

      if (!webhookSecret) {
        const errorMessage =
          "Segredo do webhook (WEBHOOK_SEC) não está configurado.";
        logger.error(errorMessage);
        response.statusCode = 500;
        response.end(errorMessage);
        return;
      }

      const stripeInstance = initializeStripe(stripeApiKey);
      logger.info(
        `Instância do Stripe inicializada: ${!stripeInstance}`,
      );

      try {
        const stripeInstance = new Stripe(
          stripeApiKey, { apiVersion: "2024-12-18.acacia" });
        const success = !stripeInstance;
        logger.info(`Stripe instance initialized successfully. ${success}`);
      } catch (error) {
        logger.error("Failed to initialize Stripe:", error);
        throw new Error("Stripe initialization failed");
      }

      // Coletar o corpo da requisição em formato bruto (Buffer)
      const chunks: Buffer[] = [];
      request.on("data", (chunk) => {
        chunks.push(chunk as Buffer);
      });

      request.on("end", async () => {
        const rawBody = Buffer.concat(chunks);
        logger.info("Tipo do Corpo:", typeof rawBody);
        logger.info("É Buffer:", Buffer.isBuffer(rawBody));

        // Acessar o cabeçalho 'stripe-signature'
        const signatureHeader = request.headers["stripe-signature"];
        if (!signatureHeader || Array.isArray(signatureHeader)) {
          const errorMessage =
            "Assinatura do Stripe ausente ou inválida nos cabeçalhos.";
          logger.error(errorMessage);
          response.statusCode = 400;
          response.end(errorMessage);
          return;
        }

        // Validar o webhook
        let event: Stripe.Event;
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

        // Processar o evento
        try {
          await processStripeEvent(event);
          logger.info(`Evento Stripe processado: ${event.type}`);
          response.statusCode = 200;
          response.end("Webhook processado com sucesso");
        } catch (err) {
          const errorMessage =
            `Erro ao processar evento: ${(err as Error).message}`;
          logger.error(errorMessage);
          response.statusCode = 500;
          response.end(errorMessage);
        }
      });

      request.on("error", (err) => {
        logger.error(`Erro ao ler a requisição: ${err.message}`);
        response.statusCode = 500;
        response.end("Erro ao ler a requisição");
      });
    } catch (error) {
      const err = error as Error;
      logger.error(`Erro no webhook: ${err.message}`, error);

      // Substituir "any" por uma interface com statusCode opcional
      interface HasStatusCode extends Error {
        statusCode?: number;
      }
      const hasStatus = error as HasStatusCode;

      const statusCode = hasStatus.statusCode ?? 500;
      response.statusCode = statusCode;
      response.end(`Erro no Webhook: ${err.message}`);
    }
  }
);
