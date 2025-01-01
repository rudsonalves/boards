// src/stripe/payments/createCheckoutSession.ts

import {
  onCall,
  CallableRequest,
  HttpsError,
} from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";

import { verifyAuth } from "../../../auth/utils/verify_auth";
import { fetchAndValidateItems } from "../utils/fetch_and_validate_items";
import { reserveItems } from "../utils/reserve_items";
import { createStripeSession } from "../utils/create_stripe_session";
import { PaymentItem } from "../interfaces/payment_item";

/**
 * Cria uma sessão de checkout no Stripe, reservando itens e retornando a URL.
 *
 * @function createCheckoutSession
 * @param {CallableRequest<PaymentItem[]>} request
 *   Objeto da requisição onCall do Firebase Functions, contendo dados e
 *   contexto de auth.
 * @returns {Promise<{ url: string }>}
 *   Retorna um objeto contendo `url`, que aponta para a sessão de checkout do
 *   Stripe.
 *
 * @throws {HttpsError}
 *   - Se o usuário não estiver autenticado.
 *   - Se `STRIPE_API_KEY` não estiver configurada.
 *   - Se qualquer erro ocorrer durante reserva de itens ou criação da sessão.
 */
export const createCheckoutSession = onCall(
  {
    region: "southamerica-east1",
    secrets: ["STRIPE_API_KEY"],
  },
  async (
    request: CallableRequest<PaymentItem[]>
  ): Promise<{ url: string }> => {
    logger.info("Iniciando função: createCheckoutSession");

    const stripeApiKey = process.env.STRIPE_API_KEY;
    if (!stripeApiKey) {
      const message = "Stripe API key not configured.";
      logger.error(message);
      throw new Error(message);
    }

    try {
      // 1. Verificar autenticação do usuário
      const userId = verifyAuth(request);

      // 2. Validar os itens
      const items = fetchAndValidateItems(request.data);

      // 3. Reservar os itens
      await reserveItems(items, userId);

      // 4. Criar sessão no Stripe
      const sessionUrl = await createStripeSession(
        items,
        userId,
        stripeApiKey,
      );

      logger.info(`session return: ${sessionUrl}`);
      return { url: sessionUrl };
    } catch (error) {
      logger.error("Error in createCheckoutSession:", error);
      throw new HttpsError("internal", (error as Error).message);
    }
  }
);
