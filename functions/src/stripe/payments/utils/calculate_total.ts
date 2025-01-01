// src/stripe/payments/utils/calculate_total.ts

import { PaymentItem } from "../interfaces/payment_item";

/**
 * Calcula o valor total em centavos baseado nos itens fornecidos.
 *
 * @function calculateTotal
 * @param {PaymentItem[]} items - Lista de itens, cada um contendo unit_price e
 *                                quantity.
 * @return {number} Valor total calculado em centavos.
 * @throws {Error} Caso `items` seja inválido ou vazio, ou se algum item não
 *                 tiver `unit_price` ou `quantity`.
 */
export function calculateTotal(items: PaymentItem[]): number {
  if (!Array.isArray(items) || items.length === 0) {
    throw new Error("Invalid items array provided for calculateTotal");
  }

  return items.reduce((total, item) => {
    if (!item.unit_price || !item.quantity) {
      throw new Error("Each item must have a unit_price and quantity");
    }

    // Multiplicamos por 100, pois o Stripe trabalha com valores em centavos.
    // `Math.round(item.unit_price * 100)` para evitar problemas de ponto
    // flutuante.
    return total + Math.round(item.unit_price * 100) * item.quantity;
  }, 0);
}
