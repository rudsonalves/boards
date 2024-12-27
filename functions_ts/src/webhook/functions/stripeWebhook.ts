// src/webhook/functions/stripeWebhook.ts

// src/webhook/functions/stripeWebhook.ts

import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import Stripe from "stripe";
import { IncomingMessage, ServerResponse } from "http";

import { processStripeEvent } from "../utils/processStripeEvent";
import { initializeStripe } from "../../payment/utils/initializeStripe";

/**
 * Função que lida com o recebimento de webhooks do Stripe, validando a
 * assinatura e processando eventos como conclusão ou falha de checkout.
 *
 * @param {IncomingMessage} request - Objeto de requisição HTTP do Firebase
 * Functions.
 * @param {ServerResponse} response - Objeto de resposta HTTP do Firebase
 * Functions.
 */
export const stripeWebhook = onRequest(
  {
    region: "southamerica-east1",
    maxInstances: 1,
    secrets: ["WEBHOOK_SEC", "STRIPE_API_KEY"],
  },
  async (request: IncomingMessage, response: ServerResponse) => {
    try {
      logger.info("Iniciando webhook...");
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
      logger.info("Instância do Stripe inicializada.");

      // Coletar o corpo da requisição
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
      logger.error(`Erro no webhook: ${err.message}`);

      const statusCode = (error as any).statusCode || 500;
      response.statusCode = statusCode;
      response.end(`Erro no Webhook: ${err.message}`);
    }
  }
);
