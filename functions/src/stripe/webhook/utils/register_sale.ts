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

import { getFirestore } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";

import { SaleData } from "../interfaces/sale_data";

/**
 * Registra uma venda no Firestore após a confirmação do pagamento.
 *
 * @async
 * @function registerSale
 * @param {SaleData} saleData - Objeto contendo os detalhes da venda.
 * @return {Promise<void>} - Completa quando a venda for registrada.
 * @throws {Error} - Caso falte algum dado essencial ou o Firestore falhe.
 */
export async function registerSale(saleData: SaleData): Promise<void> {
  const db = getFirestore();
  const saleRef = db.collection("sales").doc(saleData.paymentIntentId);

  try {
    await saleRef.set({
      buyerId: saleData.buyerId,
      sallerId: saleData.sellerId,
      amount: saleData.totalAmount,
      items: saleData.items,
      createdAt: new Date(),
    });

    logger.info("Sale registered successfully for paymentIntentId:" +
      ` ${saleData.paymentIntentId}`);
  } catch (error) {
    logger.error("Error registering sale:", error);
    throw new Error("Failed to register sale.");
  }
}
