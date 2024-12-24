// src/functions/utils/createStripeSession.ts

import Stripe from "stripe";
import { IItem } from "../../interfaces/IItem";

/**
 * Cria um PaymentIntent no Stripe.
 *
 * @function createStripePaymentIntent
 * @param {Stripe} stripeInstance - Instância inicializada do Stripe.
 * @param {number} totalAmount - Valor total em centavos.
 * @param {string} userId - UID do usuário.
 * @param {IItem[]} items - Lista de itens para o pagamento.
 * @return {Promise<Object>} - Objeto do PaymentIntent criado.
 *
 * @description
 * Esta função cria um PaymentIntent configurado para aceitar pagamento
 * em cartão ou boleto, em BRL, com metadata que inclui o `userId`
 * e os itens da compra.
 */
export async function createStripePaymentIntent(
  stripeInstance: Stripe,
  totalAmount: number,
  userId: string,
  items: IItem[],
): Promise<Stripe.Response<Stripe.PaymentIntent>> {
  return stripeInstance.paymentIntents.create({
    amount: totalAmount,
    payment_method_types: ["card", "boleto"],
    description: "Compra de produtos",
    currency: "brl",
    metadata: {
      userId,
      items: JSON.stringify(items),
    },
  });
}
