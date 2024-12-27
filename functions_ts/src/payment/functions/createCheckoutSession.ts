// src/functions/payment/createCheckoutSession.ts

import { onCall, HttpsError } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";

import { verifyAuth } from "../../auth/utils/verifyAuth";
import { fetchAndValidateItems } from "../utils/fetchAndValidateItems";
import { reserveItems } from "../utils/reserveItems";
import { createStripeSession } from "../utils/createStripeSession";
import { initializeStripe } from "../utils/initializeStripe";

/**
 * Função para criar uma sessão de checkout no Stripe.
 *
 * Esta função realiza o processo de checkout, executando os seguintes passos:
 * 1. Verifica a autenticação do usuário.
 * 2. Valida os itens solicitados para a compra.
 * 3. Reserva temporariamente os itens no banco de dados.
 * 4. Cria uma sessão de checkout no Stripe e retorna a URL da sessão.
 *
 * @async
 * @function createCheckoutSession
 * @param data - Objeto de requisição contendo os dados do usuário e itens da
 *               compra.
 * @param context - Contexto do Firebase Functions (onCall).
 * @throws {HttpsError} - Lança um erro "internal" caso qualquer etapa do
 *                        processo falhe.
 * @returns {Promise<{ url: string }>} - Retorna um objeto contendo a URL da
 *                                       sessão de checkout do Stripe.
 */
export const createCheckoutSession = onCall(
  {
    region: "southamerica-east1",
    secrets: ["STRIPE_API_KEY"],
  },
  async (data: any, context: any): Promise<{ url: string | null }> => {
    try {
      // 1. Verificar autenticação do usuário
      const userId = verifyAuth(context);

      // 2. Validar os itens
      const items = fetchAndValidateItems(data);

      // 3. Reservar os itens
      await reserveItems(items, userId);

      // 4. Criar sessão no Stripe
      const stripeApiKey = context.env.STRIPE_API_KEY;
      if (!stripeApiKey) {
        throw new HttpsError(
          "internal", "Stripe API Key is missing from secret.");
      }
      const stripeInstance = initializeStripe(stripeApiKey);
      const sessionUrl = await createStripeSession(
        items,
        userId,
        stripeInstance,
      );

      logger.info("Session created successfully", { sessionUrl });
      return { url: sessionUrl };
    } catch (error: unknown) {
      const errorMessage = error instanceof Error ?
        error.message :
        "Unknown error occurred.";
      logger.error("Error in createCheckoutSession", { error: errorMessage });
      throw new HttpsError("internal", errorMessage);
    }
  }
);
