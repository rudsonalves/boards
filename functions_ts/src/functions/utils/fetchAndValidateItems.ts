// src/functions/utils/validateItems.ts

import { HttpsError } from "firebase-functions/v2/https";
import { IItem } from "../../interfaces/IItem";

/**
 * Valida e retorna os itens enviados na requisição.
 *
 * @function validateItems
 * @param {Object} data - Objeto da requisição Firebase Functions (onCall).
 * @return {Array} - Lista de itens validados.
 * @throws {HttpsError} - Caso items não sejam encontrados ou não sejam um
 *                        array válido.
 */
export function fetchAndValidateItems(
  data: Record<string, any>
): Array<IItem> {
  const items = data.items;

  if (!items || !Array.isArray(items)) {
    throw new HttpsError("invalid-argument", "Items must be an array.");
  }

  return items;
}
