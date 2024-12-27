// src/stripe/utils/reserveItems.ts

import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";

import { IItem } from "../interfaces/IItem";

/**
 * Reserva os itens selecionados pelo usuário, decrementando a quantidade
 * em estoque e criando/atualizando um registro de reserva no Firestore.
 *
 * @async
 * @function reserveItems
 * @param {Array<Object>} items - Lista de itens, cada item contendo adId e
 *                                quantity.
 * @param {string} userId - UID do usuário que está fazendo a reserva.
 * @return {Promise<void>} - Completa quando a reserva estiver confirmada.
 * @throws {HttpsError} - Caso o item não exista, não haja estoque suficiente ou
 *                        o usuário não esteja autenticado.
 */
export async function reserveItems(
  items: IItem[],
  userId: string,
): Promise<void> {
  const db = getFirestore();
  const batch = db.batch();
  const now = Date.now();
  const reservedUntil = now + 30 * 60 * 1000; // 30 min

  for (const item of items) {
    const adRef = db.collection("ads").doc(item.adId);
    const reserveRef = adRef.collection("reserve").doc(userId);
    logger.info(`userId: ${userId} -> adId: ${item.adId}`);

    const adDoc = await adRef.get();
    if (!adDoc.exists) {
      throw new HttpsError("not-found", `Item not found: ${item.adId}`);
    }

    const adData = adDoc.data() as {
      quantity: number;
      title: string;
      status: string,
    };

    // Verifica se existe uma reserva para este item neste userId
    const reservedItem = await reserveRef.get();
    if (reservedItem.exists) {
      const reservedData = reservedItem.data() as { quantity: number };

      if (reservedData.quantity === item.quantity) {
        // Apenas altera o tempo de expiração da reserva
        batch.update(reserveRef, { reservedUntil: reservedUntil });
        logger.info("Updating reservedUntil for existing reservation");
        continue;
      }

      // Corrige a quantidade da reserva e no estoque
      const quantityDiff = reservedData.quantity - item.quantity;
      logger.info(
        `Adjusting reservation: ReservedQt=${reservedData.quantity},
         NewQt=${item.quantity}, Diff=${quantityDiff}`
      );

      const newQuantity = adData.quantity + quantityDiff;
      // Atualiza ad
      batch.update(adRef, {
        quantity: newQuantity,
        status: newQuantity === 0 ? "sold" : adData.status,
      });

      // Atualiza reserve
      batch.set(reserveRef, {
        quantity: item.quantity,
        reservedUntil: reservedUntil,
      });
    } else {
      logger.info("Creating new reservation.");
      // Atualiza ad
      batch.update(adRef, {
        quantity: FieldValue.increment(-item.quantity),
        status: adData.quantity - item.quantity === 0 ? "sold" : adData.status,
      });

      // Cria nova reserve
      batch.set(reserveRef, {
        quantity: item.quantity,
        reservedUntil: reservedUntil,
      });
    }

    // Commit do batch
    await batch.commit();
    logger.info("Items reserved successfully.");
  }
}
