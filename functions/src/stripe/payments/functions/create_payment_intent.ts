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

import {
  onCall,
  CallableRequest,
  HttpsError,
} from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { initializeStripe } from "../../utils/initialize_stripe";
import { verifyAuth } from "../../../auth/utils/verify_auth";
import { fetchAndValidateItems } from "../utils/fetch_and_validate_items";
import {
  createStripePaymentIntent,
} from "../utils/create_stripe_payment_intent";
import { PaymentData } from "../interfaces/payment_item";

/**
 * Cria um PaymentIntent no Stripe, retornando um client_secret para realizar o
 * pagamento.
 *
 * @function createPaymentIntent
 * @param {CallableRequest<PaymentData>} request
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
    request: CallableRequest<PaymentData>
  ): Promise<{ clientSecret: string | unknown }> => {
    logger.info("Iniciando função: createPaymentIntent");

    try {
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

      // Validar e coletar informações
      const { buyerId, sellerId, items } = request.data;
      const { validatedItems, totalAmount } =
        await fetchAndValidateItems(items);

      // userId deve ser o mesmo que o buyerId
      if (userId !== buyerId) {
        logger.warn(
          `Usuário comprador está inconsistente: ${userId}/${buyerId}`);
      }

      // Cria um PaymentIntent no Stripe
      const paymentIntent = await createStripePaymentIntent(stripeInstance, {
        buyerId,
        sellerId,
        totalAmount,
        items: validatedItems,
      });

      logger.info("PaymentIntent criado com sucesso.");
      return { clientSecret: paymentIntent.client_secret };
    } catch (error) {
      logger.error("Error in createPaymentIntent:", error);
      throw new HttpsError("internal", (error as Error).message);
    }
  }
);
