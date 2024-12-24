// src/functions/createPaymentIntent.ts

import { onCall, HttpsError } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";

import { initializeStripe } from "./utils/initializeStripe";
import { verifyAuth } from "./utils/verifyAuth";
import { fetchAndValidateItems } from "./utils/fetchAndValidateItems";
import { calculateTotal } from "./utils/calculateTotal";
import { createStripePaymentIntent } from "./utils/createStripePaymentIntent";

/**
 * Cria um PaymentIntent no Stripe, retornando um client_secret para realizar
 * o pagamento.
 *
 * @function createPaymentIntent
 * @param {Object} data - Objeto da requisição onCall do Firebase Functions.
 * @param {CallableContext} context - Contexto da requisição onCall.
 * @return {Promise<Object>} - Retorna um objeto contendo o clientSecret do
 *                             PaymentIntent.
 */
export const createPaymentIntent = onCall(
  {
    region: "southamerica-east1",
    secrets: ["STRIPE_API_KEY"],
  },
  async (
    request: any,
  ): Promise<{ clientSecret: string }> => {
    try {
      // Inicializa o Stripe usando a secret do ambiente
      const stripeInstance = initializeStripe();

      // Verifica a autenticação do usuário
      const userId = verifyAuth(request);

      if (!userId) {
        logger.error(`User is not logged in: ${userId}`);
        throw new HttpsError("unauthenticated", "User is not logged in.");
      }

      // Valida os itens enviados na requisição
      const items = fetchAndValidateItems(request);

      // Calcula o valor total dos itens em centavos
      const totalAmount = calculateTotal(items);

      // Cria um PaymentIntent no Stripe
      const paymentIntent = await createStripePaymentIntent(
        stripeInstance,
        totalAmount,
        userId,
        items,
      );

      if (!paymentIntent.client_secret) {
        throw new HttpsError(
          "internal",
          "Failed to retrieve client secret for the PaymentIntent.",
        );
      }

      logger.info("PaymentIntent created successfully.", { paymentIntent });
      return { clientSecret: paymentIntent.client_secret };
    } catch (error: any) {
      logger.error("Error in createPaymentIntent.", { error });
      throw new HttpsError(
        "internal",
        error.message || "Failed to create PaymentIntent.");
    }
  }
);
