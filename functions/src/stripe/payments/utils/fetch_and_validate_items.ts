// src/stripe/payments/utils/fetch_and_validate_items.ts

import {
  PaymentItem,
} from "../interfaces/payment_item";

/**
 * Valida e retorna os itens enviados na requisição.
 *
 * @function fetchAndValidateItems
 * @param {PaymentItem[]} request - Objeto da requisição
 *                                (ex.: onCall) contendo `items`.
 * @return {PaymentItem[]} Lista de itens validados.
 * @throws {Error} Caso `items` não exista ou não seja um array válido.
 */
export function fetchAndValidateItems(
  request: PaymentItem[],
): PaymentItem[] {
  const items = request;
  if (!items || !Array.isArray(items)) {
    throw new Error("Items must be a valid array.");
  }
  return items;
}
