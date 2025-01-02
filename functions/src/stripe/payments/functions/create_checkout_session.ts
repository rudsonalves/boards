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

import { verifyAuth } from "../../../auth/utils/verify_auth";
import { fetchAndValidateItems } from "../utils/fetch_and_validate_items";
import { reserveItems } from "../utils/reserve_items";
import { createStripeSession } from "../utils/create_stripe_session";
import { PaymentItems } from "../interfaces/payment_item";

/**
 * Cria uma sessão de checkout no Stripe, reservando itens e retornando a URL.
 *
 * @function createCheckoutSession
 * @param {CallableRequest<PaymentItems>} request
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
    request: CallableRequest<PaymentItems>
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
      logger.info("request.data: ");
      logger.info(request.data);
      const reqData = request.data;
      const items = fetchAndValidateItems(reqData.items);

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
