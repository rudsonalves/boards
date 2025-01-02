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

import { logger } from "firebase-functions/v2";
import {
  IItem,
} from "../interfaces/payment_item";

/**
 * Valida e retorna os itens enviados na requisição.
 *
 * @function fetchAndValidateItems
 * @param {IItem[]} request - Objeto da requisição
 *                                (ex.: onCall) contendo `items`.
 * @return {IItem[]} Lista de itens validados.
 * @throws {Error} Caso `items` não exista ou não seja um array válido.
 */
export function fetchAndValidateItems(
  request: IItem[],
): IItem[] {
  const items = request;
  if (!items || !Array.isArray(items)) {
    logger.error(`Items must be a valid arra: ${items}`);
    throw new Error("Items must be a valid array.");
  }
  return items;
}
