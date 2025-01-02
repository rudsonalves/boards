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

// src/stripe/payments/utils/calculate_total.ts

import { IItem } from "../interfaces/payment_item";

/**
 * Calcula o valor total em centavos baseado nos itens fornecidos.
 *
 * @function calculateTotal
 * @param {IItem[]} items - Lista de itens, cada um contendo unit_price e
 *                                quantity.
 * @return {number} Valor total calculado em centavos.
 * @throws {Error} Caso `items` seja inválido ou vazio, ou se algum item não
 *                 tiver `unit_price` ou `quantity`.
 */
export function calculateTotal(items: IItem[]): number {
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
