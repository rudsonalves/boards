const {onCall, HttpsError} = require("firebase-functions/v2/https");

const {initializeStripe} = require("../ultils/initializeStripe");
const {verifyAuth} = require("./utils/verifyAuth");
const {fetchAndValidateItems} = require("./utils/fetchAndValidateItems");
const {calculateTotal} = require("./utils/calculateTotal");
const {createStripePaymentIntent} =
  require("./utils/createStripePaymentIntent");

/**
 * Cria um PaymentIntent no Stripe, retornando um client_secret para realizar
 * o pagamento.
 *
 * @function createPaymentIntent
 * @param {Object} request - Objeto da requisição onCall do Firebase Functions.
 * @return {Promise<Object>} - Retorna um objeto contendo o clientSecret do
 *                             PaymentIntent.
 * @description
 * 1. Verifica se o usuário está autenticado.
 * 2. Valida a lista de itens.
 * 3. Calcula o valor total dos itens.
 * 4. Cria um PaymentIntent no Stripe e retorna o clientSecret para o front-end.
 *
 * @throws {HttpsError} - Caso o usuário não esteja autenticado, os itens sejam
 *                        inválidos ou ocorra erro ao criar o PaymentIntent.
 */
exports.createPaymentIntent = onCall(
    {
      region: "southamerica-east1",
      secrets: ["STRIPE_API_KEY"],
    },
    async (request) => {
      try {
      // Log dos dados recebidos
        console.log("Request Data:", request.data);
        console.log("Request Auth:", request.auth);

        // Validar stripeApiKey
        const stripeApiKey = process.env.STRIPE_API_KEY;
        if (!stripeApiKey) {
          const message = "Stripe API key not configured.";
          console.error(message);
          throw new Error(message);
        }

        // Inicie o Stripe usando a secret do ambiente
        const stripeInstance = initializeStripe(stripeApiKey);

        // Verificar autenticação do usuário
        const userId = verifyAuth(request);

        // Verificar se os itens foram enviados
        const items = fetchAndValidateItems(request.data);

        // Calcula o valor total em centavos
        const totalAmount = calculateTotal(items);

        // Cria um PaymentIntent no Stripe
        const paymentIntent = await createStripePaymentIntent(stripeInstance, {
          totalAmount,
          userId,
          items,
        });

        return {clientSecret: paymentIntent.client_secret};
      } catch (error) {
        console.error("Error in createPaymentIntent:", error);
        throw new HttpsError("internal", error.message);
      }
    },
);
