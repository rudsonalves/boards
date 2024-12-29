const {db, FieldValue} = require("./db");

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
 * @throws {HttpsError} - Caso o item não exista, não haja estoque suficiente
 *                         ou o usuário não esteja autenticado.
 */
async function reserveItems(items, userId) {
  if (!userId) {
    throw new Error("User ID is required for reservation.");
  }

  const batch = db.batch();
  const now = Date.now();
  const reservedUntil = now + 30 * 60 * 1000; // 30 minutos

  for (const item of items) {
    const adRef = db.collection("ads").doc(item.adId);
    const reserveRef = adRef.collection("reserve").doc(userId);
    console.log(`userId: ${userId} -> adId: ${item.adId}`);

    const adDoc = await adRef.get();

    if (!adDoc.exists) {
      throw new Error(`Item not found: ${item.adId}`);
    }

    const adData = adDoc.data();

    if (adData.quantity < item.quantity) {
      throw new Error(
          `Not enough stock for item ${adData.title}.
         Available: ${adData.quantity}, Requested: ${item.quantity}`,
      );
    }

    const reservedItem = await reserveRef.get();
    if (reservedItem.exists) {
      const reservedData = reservedItem.data();

      if (reservedData.quantity === item.quantity) {
        console.log("Updating reservedUntil for existing reservation");
        batch.update(reserveRef, {reservedUntil});
        continue;
      }

      const quantityDiff = reservedData.quantity - item.quantity;

      console.log(
          `Adjusting reservation: ReservedQt=${reservedData.quantity},
        NewQt=${item.quantity}, Diff=${quantityDiff}`,
      );

      const newQuantity = adData.quantity + quantityDiff;
      batch.update(adRef, {
        quantity: newQuantity,
        status: newQuantity === 0 ? "sold" : adData.status,
      });

      batch.set(reserveRef, {
        quantity: item.quantity,
        reservedUntil,
      });
    } else {
      console.log("Creating new reservation.");
      batch.update(adRef, {
        quantity: FieldValue.increment(-item.quantity),
        status: adData.quantity - item.quantity === 0 ? "sold" : adData.status,
      });

      batch.set(reserveRef, {
        quantity: item.quantity,
        reservedUntil,
      });
    }
  }

  await batch.commit();
  console.log("Items reserved successfully.");
}

module.exports = {reserveItems};
