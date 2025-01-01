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

// src/stripe/payments/utils/create_stripe_session.ts

import { Stripe } from "stripe";
import { initializeStripe } from "../../utils/initialize_stripe";

/**
 * Interface para cada item reservado.
 */
export interface CheckoutItem {
  title: string;
  unit_price: number;
  quantity: number;
}

/**
 * Cria uma sessão de checkout no Stripe com base nos itens reservados.
 *
 * @async
 * @function createStripeSession
 * @param {CheckoutItem[]} items - Lista de itens reservados para checkout,
 *                                 contendo title, unit_price e quantity.
 * @param {string} userId - UID do usuário autenticado.
 * @param {string} stripeApiKey - Chave de API do Stripe.
 * @return {Promise<string>} - Retorna a URL da sessão de checkout do Stripe.
 * @throws {Error} - Caso a chave da API do Stripe não esteja configurada
 *                   ou haja falha na criação da sessão.
 */
export async function createStripeSession(
  items: CheckoutItem[],
  userId: string,
  stripeApiKey: string
): Promise<string> {
  const now = Math.floor(Date.now() / 1000); // Tempo atual em segundos
  const expiresAt = now + 30 * 60; // 30 minutos em segundos

  const stripeInstance = initializeStripe(stripeApiKey);

  const lineItems = items.map((item) => ({
    price_data: {
      currency: "brl",
      product_data: { name: item.title },
      unit_amount: Math.round(item.unit_price * 100),
    },
    quantity: item.quantity,
  }));

  const session: Stripe.Checkout.Session =
    await stripeInstance.checkout.sessions.create({
      payment_method_types: ["card", "boleto"],
      line_items: lineItems,
      mode: "payment",
      success_url: "https://rralves.dev.br/boards-pagamento-sucesso/",
      cancel_url: "https://rralves.dev.br/boards-pagamento-cancelado/",
      locale: "pt-BR",
      payment_method_options: {
        card: {
          installments: { enabled: true },
        },
      },
      metadata: {
        userId,
        items: JSON.stringify(items),
      },
      expires_at: expiresAt,
    });

  console.log("createStripeSession resolved");
  return session.url ?? "";
}
