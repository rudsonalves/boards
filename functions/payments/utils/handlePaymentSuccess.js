const {db} = require("./db");

/**
 * Trata o evento de sucesso no pagamento do Stripe, removendo reservas
 * dos itens já comprados.
 *
 * @async
 * @function handlePaymentSuccess
 * @param {Object} session - Objeto da sessão do Stripe (checkout.session).
 * @description
 * Extrai o userId e itens do metadata da sessão, remove as reservas
 * correspondentes do Firestore, confirmando assim a compra do(s) item(ns).
 *
 * @throws {Error} - Caso falte metadata ou items no session.
 */
async function handlePaymentSuccess(session) {
  console.log(`Starting handlePaymentSuccess:`);

  const metadata = session.metadata;
  if (!metadata || !metadata.items || !metadata.userId) {
    console.error("Metadata missing in session:", session.id);
    return;
  }

  const items = JSON.parse(metadata.items);
  const userId = metadata.userId;

  const batch = db.batch();

  for (const item of items) {
    const reserveRef = db
        .collection("ads")
        .doc(item.adId)
        .collection("reserve")
        .doc(userId);

    // Remove a reserva ao confirmar a venda
    batch.delete(reserveRef);
  }

  await batch.commit();
  console.log(
      `Payment confirmed and reservations cleared for user: ${userId}`);
}

module.exports = {handlePaymentSuccess};
