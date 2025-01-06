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

// src/stripe/payments/utils/reserve_items.ts

import { getFirestore } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";

import { IItem } from "../interfaces/payment_item";
import { ReserveData } from "../interfaces/reserve_date";
import { COLLECTIONS } from "../../../utils/collections";
import { ADSTATUS } from "../../../utils/ad_status";

/**
 * Reserva os itens selecionados pelo usuário, decrementando a quantidade
 * em estoque e criando/atualizando um registro de reserva no Firestore.
 *
 * @async
 * @function reserveItems
 * @param {IItem[]} items - Lista de itens, cada item contendo adId e
 *                                    quantity.
 * @param {string} userId - UID do usuário que está fazendo a reserva.
 * @return {Promise<void>} - Completa quando a reserva estiver confirmada.
 * @throws {Error} - Caso o item não exista, não haja estoque suficiente ou se
 *                   userId estiver ausente.
 */
export async function reserveItems(
  items: IItem[],
  userId: string,
): Promise<void> {
  if (!userId) {
    throw new Error("User ID is required for reservation.");
  }

  const firestore = getFirestore();
  const batch = firestore.batch();

  // Defina no início
  const now = Date.now();
  const reservedUntil = new Date(now + 30 * 60 * 1000);

  for (const item of items) {
    const adRef = firestore
      .collection(COLLECTIONS.ADS)
      .doc(item.adId);
    const reserveRef = adRef
      .collection(COLLECTIONS.RESERVE)
      .doc(userId);

    logger.info(`Reserving item for userId=${userId}, adId=${item.adId}`);

    // Baixa o produto e verifica se existe
    const adDoc = await adRef.get();
    if (!adDoc.exists) {
      throw new Error(`Item not found: ${item.adId}`);
    }

    const adData = adDoc.data();
    if (!adData) {
      throw new Error(`Invalid ad data for item: ${item.adId}`);
    }

    // Verifica se o produto esta ativo
    if (adData.status !== ADSTATUS.ACTIVE &&
      adData.status !== ADSTATUS.RESERVED) {
      throw new Error(`Ad ${item.adId} has status "${adData.status}"`);
    }

    let stock: number;

    // Recupera a reserva, se existir
    const existingReserveSnap = await reserveRef.get();
    if (existingReserveSnap.exists) {
      logger.info("Update reservation.");
      const existingReserveData = existingReserveSnap.data();
      if (!existingReserveData) {
        const message = "Update reserve error. Reserve data is null:" +
          ` userId=${userId}, adId=${item.adId}`;
        logger.error(message);
        throw new Error(message);
      }

      // Restaura estoque com a reserva anterior
      adData.quantity += existingReserveData.quantity;

      // Verifica se existe produto suficiente em estoque
      stock = adData.quantity - item.quantity;
      if (stock < 0) {
        const message =
          `There is not enough product in stock: adId ${item.adId}`;
        logger.error(message);
        throw new Error(message);
      }
    } else {
      logger.info("Creating new reservation.");
      // Verifica se existe produto suficiente em estoque
      stock = adData.quantity - item.quantity;
      if (stock < 0) {
        const message =
          `There is not enough product in stock: adId ${item.adId}`;
        logger.error(message);
        throw new Error(message);
      }
    }

    // Atualizar reserva
    batch.set(reserveRef, {
      quantity: item.quantity,
      reservedUntil: reservedUntil,
    } as ReserveData);

    // Atualizar Anúncio
    batch.update(adRef, {
      quantity: stock,
      status: stock === 0 ? ADSTATUS.RESERVED : adData.status,
    });
  }

  await batch.commit();
  logger.info("Items reserved successfully.");
}
