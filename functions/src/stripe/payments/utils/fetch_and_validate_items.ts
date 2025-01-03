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

import {
  IItem,
} from "../interfaces/payment_item";
import { getFirestore } from "firebase-admin/firestore";

/**
 * Valida e retorna os itens enviados na requisição.
 *
 * @function fetchAndValidateItems
 * @param {IItem[]} items - Objeto da requisição
 *                          (ex.: onCall) contendo `items`.
 * @return {Promise<{ validatedItems: IItem[], totalAmount: number }>}
 *                        - Lista de itens validados.
 * @throws {Error} Caso `items` não exista ou não seja um array válido.
 */
export async function fetchAndValidateItems(
  items: IItem[],
): Promise<{ validatedItems: IItem[]; totalAmount: number }> {
  const db = getFirestore();

  // Obtendo todas as referências de uma vez
  const adRefs = items.map((item) => db.collection("ads").doc(item.adId));

  // Executando todas as buscas de uma vez
  const adSnaps = await Promise.all(adRefs.map((ref) => ref.get()));

  let totalAmount = 0;
  const validatedItems: IItem[] = [];

  adSnaps.forEach((adSnap, index) => {
    const item = items[index];

    if (!adSnap.exists) {
      throw new Error(`Item not found: ${item.adId}`);
    }

    const adData = adSnap.data();
    if (!adData || adData.price !== item.unit_price) {
      throw new Error(`Price mismatch for item: ${item.adId}`);
    }

    totalAmount += Math.round(adData.price * 100) * item.quantity;
    validatedItems.push({
      ...item,
      unit_price: adData.price,
    });
  });

  return { validatedItems, totalAmount };
}
