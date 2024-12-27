// src/stripe/utils/createStripeSession.ts

import { HttpsError } from "firebase-functions/v2/https";
import { IItem } from "../interfaces/IItem";
import { logger } from "firebase-functions/v2";
import Stripe from "stripe";

/**
 * Cria uma sessão de checkout no Stripe com base nos itens reservados.
 *
 * @async
 * @function createStripeSession
 * @param {IItem[]} items - Lista de itens reservados para checkout, contendo
 *                          title, unit_price e quantity.
 * @param {string} userId - UID do usuário autenticado.
 * @param {Stripe} stripeInstance - Instância do Stripe.
 * @return {Promise<string>} - Retorna a URL da sessão de checkout do Stripe.
 * @throws {HttpsError} - Caso a chave da API do Stripe não esteja configurada
 *                        ou haja falha na criação da sessão.
 */
export async function createStripeSession(
  items: IItem[],
  userId: string,
  stripeInstance: Stripe,
): Promise<string | null> {
  const now = Math.floor(Date.now() / 1000); // Tempo atual em segundos
  const expiresAt = now + 30 * 60; // 30 minutos em segundos

  // Validação simples
  if (items.length === 0) {
    const message = "Items array is empty. Cannot create a Stripe session.";
    logger.error(message);
    throw new HttpsError("invalid-argument", message);
  }

  // Cria os line_items para a sessão de checkout
  const lineItems = items.map((item) => ({
    price_data: {
      currency: "brl",
      product_data: { name: item.title },
      // Stripe trabalha com centavos
      unit_amount: Math.round(item.unit_price * 100),
    },
    quantity: item.quantity,
  }));

  try {
    const session = await stripeInstance.checkout.sessions.create({
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

    logger.info(`createStripeSession resolved: ${session.url}`);
    return session.url;
  } catch (error) {
    logger.error("Error creating Stripe session:", error);
    throw new HttpsError("internal", "Failed to create Stripe session.");
  }
}
