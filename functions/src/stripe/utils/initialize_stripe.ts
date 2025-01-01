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

// src/stripe/utils/initialize_stripe.ts

import { logger } from "firebase-functions/v2";
import Stripe from "stripe";

/**
 * Inicializa a instância do Stripe usando as chaves de API apropriadas.
 *
 * @function initializeStripe
 * @param {string} stripeApiKey - Chave de API do Stripe.
 * @return {Stripe} - Instância do Stripe.
 * @throws {Error} - Caso a chave da API do Stripe não esteja configurada.
 */
export function initializeStripe(stripeApiKey: string): Stripe {
  if (!stripeApiKey) {
    const message = "Stripe API key not configured.";
    logger.error(message);
    throw new Error(message);
  }

  return new Stripe(stripeApiKey, { apiVersion: "2024-12-18.acacia" });
}
