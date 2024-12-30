const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {logger} = require("firebase-functions/v2");

const {verifyAuth} = require("./utils/verifyAuth");
const {fetchAndValidateItems} = require("./utils/fetchAndValidateItems");
const {reserveItems} = require("./utils/reserveItems");
const {createStripeSession} = require("./utils/createStripeSession");

exports.createCheckoutSession = onCall(
    {
      region: "southamerica-east1",
      secrets: ["STRIPE_API_KEY"],
    },
    async (request) => {
      try {
        // 1. Verificar autenticação do usuário
        const userId = verifyAuth(request);

        // 2. Validar os itens
        const items = fetchAndValidateItems(request);

        // 3. Reservar os itens
        await reserveItems(items, userId);

        // 4. Criar sessão no Stripe
        const stripeApiKey = process.env.STRIPE_API_KEY;
        if (!stripeApiKey) {
          const message = "Stripe API key not configured.";
          logger.error(message);
          throw new Error(message);
        }

        const sessionUrl = await createStripeSession(
            items,
            userId,
            stripeApiKey,
        );

        logger.info(`session return: ${sessionUrl}`);
        return {url: sessionUrl};
      } catch (error) {
        logger.error("Error in createCheckoutSession:", error);
        throw new HttpsError("internal", error.message);
      }
    },
);
