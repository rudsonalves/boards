const {onRequest} = require("firebase-functions/v2/https");

const {initializeStripe} = require("../ultils/initializeStripe");
const {processStripeEvent} = require("./utils/processStripeEvent");
const {validateWebhook} = require("./utils/validateWebhook");


/**
 * Função que lida com o recebimento de webhooks do Stripe, validando a
 * assinatura e processando eventos como conclusão ou falha de checkout.
 *
 * @function stripeWebhook
 * @param {Object} request - Objeto de requisição HTTP do Firebase Functions.
 * @param {Object} response - Objeto de resposta HTTP do Firebase Functions.
 * @description
 * Esta função é acionada quando o Stripe envia um evento (webhook) para o
 * endpoint.
 * Ela valida a origem e a integridade do evento, processa-o de acordo com
 * seu tipo, e envia uma resposta apropriada (200 para sucesso, 400 ou 500
 * para erros).
 *
 * @throws {Error} - Lança erro caso não seja possível validar o webhook,
 *                   processar o evento ou acessar as chaves de ambiente.
 */
exports.stripeWebhook = onRequest(
    {
      region: "southamerica-east1",
      secrets: ["STRIPE_API_KEY", "WEBHOOK_SEC"],
      maxInstances: 1,
      enforceRawBody: true,
    },
    async (request, response) => {
      try {
        console.log("Starting webhook.");

        // Validar stripeApiKey
        const stripeApiKey = process.env.STRIPE_API_KEY;
        if (!stripeApiKey) {
          const message = "Stripe API key not configured.";
          console.error(message);
          throw new Error(message);
        }

        // Inicializa a instância do Stripe
        const stripeInstance = initializeStripe(stripeApiKey);

        // Validar webhookSecret
        const webhookSecret = process.env.WEBHOOK_SEC;
        if (!webhookSecret) {
          console.error("WEBHOOK_SEC is not defined.");
          throw new Error("Webhook secret not configured.");
        }

        // Valida o evento recebido do Stripe
        const event = validateWebhook(
            request,
            stripeInstance,
            webhookSecret,
        );

        console.log(`Evento Stripe validado: ${event.type}`);
        // Processa o evento do Stripe
        await processStripeEvent(event);

        response.status(200).send("Webhook processado com sucesso");
      } catch (err) {
        console.error(`Erro no webhook: ${err.message}`);
        response.status(err.statusCode || 500)
            .send(`Erro no Webhook: ${err.message}`);
      }
    },
);
