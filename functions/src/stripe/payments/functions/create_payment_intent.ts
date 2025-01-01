// src/stripe/payments/functions/create_payment_intent.ts

import {
  onCall,
  CallableRequest,
  HttpsError,
} from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { initializeStripe } from "../../utils/initialize_stripe";
import { verifyAuth } from "../../../auth/utils/verify_auth";
import { fetchAndValidateItems } from "../utils/fetch_and_validate_items";
import { calculateTotal } from "../utils/calculate_total";
import {
  createStripePaymentIntent,
} from "../utils/create_stripe_payment_intent";
import { PaymentItem } from "../interfaces/payment_item";

/**
 * Cria um PaymentIntent no Stripe, retornando um client_secret para realizar o
 * pagamento.
 *
 * @function createPaymentIntent
 * @param {CallableRequest<PaymentItem[]>} request
 *   Objeto da requisição onCall do Firebase Functions, contendo data e auth.
 * @returns {Promise<{ clientSecret: string }>}
 *   Retorna um objeto contendo o clientSecret do PaymentIntent criado no
 *   Stripe.
 *
 * @description
 *  1. Verifica se o usuário está autenticado.
 *  2. Valida a lista de itens (request.data.items).
 *  3. Calcula o valor total dos itens.
 *  4. Cria um PaymentIntent no Stripe e retorna o clientSecret.
 *
 * @throws {HttpsError} - Caso o usuário não esteja autenticado, os itens sejam
 *                        inválidos ou ocorra erro ao criar o PaymentIntent.
 */
export const createPaymentIntent = onCall(
  {
    region: "southamerica-east1",
    secrets: ["STRIPE_API_KEY"],
  },
  async (
    request: CallableRequest<PaymentItem[]>
  ): Promise<{ clientSecret: string | unknown }> => {
    logger.info("Iniciando função: createPaymentIntent");

    try {
      logger.info("Request Data:", request.data);
      logger.info("Request Auth:", request.auth);

      // Validar stripeApiKey
      const stripeApiKey = process.env.STRIPE_API_KEY;
      if (!stripeApiKey) {
        const message = "Stripe API key not configured.";
        logger.error(message);
        throw new Error(message);
      }

      // Inicia o Stripe usando a secret do ambiente
      const stripeInstance = initializeStripe(stripeApiKey);

      // Verificar autenticação do usuário
      const userId = verifyAuth(request);

      // Verificar se os itens foram enviados e são válidos
      const items = fetchAndValidateItems(request.data);

      // Calcula o valor total em centavos
      const totalAmount = calculateTotal(items);

      // Cria um PaymentIntent no Stripe
      const paymentIntent = await createStripePaymentIntent(stripeInstance, {
        totalAmount,
        userId: userId,
        items,
      });

      return { clientSecret: paymentIntent.client_secret };
    } catch (error) {
      logger.error("Error in createPaymentIntent:", error);
      throw new HttpsError("internal", (error as Error).message);
    }
  }
);
