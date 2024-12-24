// src/functions/utils/createStripeSession.ts

import { IItem } from "../../interfaces/IItem";

/**
 * Calcula o valor total em centavos dos itens.
 *
 * @param {IItem[]} items - Lista de itens validados.
 * @return {number} - Valor total em centavos.
 */
export function calculateTotal(items: IItem[]): number {
  return items.reduce(
    (total, item) => total + item.unit_price * item.quantity,
    0,
  );
}
