const {db, FieldValue} = require("../../ultils/db");

/**
 * Trata eventos de falha ou expiração do checkout do Stripe, restaurando o
 * estoque dos itens e removendo as reservas.
 *
 * @async
 * @function handlePaymentFailure
 * @param {Object} session - Objeto da sessão do Stripe (checkout.session).
 * @description
 * Extrai o userId e itens do metadata, restaura a quantidade original dos
 * produtos no estoque do Firestore e remove as reservas, já que o pagamento
 * não foi concluído.
 *
 * @throws {Error} - Caso falte metadata ou items no session.
 */
async function handlePaymentFailure(session) {
  console.log(`Starting handlePaymentFailure:`);

  const metadata = session.metadata;
  if (!metadata || !metadata.items || !metadata.userId) {
    console.error("Metadata missing in session:", session.id);
    return;
  }

  const items = JSON.parse(metadata.items);
  const userId = metadata.userId;

  const batch = db.batch();

  for (const item of items) {
    const adRef = db.collection("ads").doc(item.adId);
    const reserveRef = adRef.collection("reserve").doc(userId);

    const reservedQty = item.quantity;

    // Restaurar o estoque
    batch.update(adRef, {
      quantity: FieldValue.increment(reservedQty),
    });

    // Remove reserva
    batch.delete(reserveRef);
    console.log(`Restoring stock for user: ${userId}, adId: ${item.adId},` +
      ` qty: ${item.quantity}`,
    );
  }

  await batch.commit();
  console.log(`Stock restored for user: ${userId}`);
}

module.exports = {handlePaymentFailure};
