/**
 * Cria um PaymentIntent no Stripe.
 *
 * @function createStripePaymentIntent
 * @param {Object} stripeInstance - Instância inicializada do Stripe.
 * @param {Object} params - Parâmetros para o PaymentIntent.
 * @param {number} params.totalAmount - Valor total em centavos.
 * @param {string} params.userId - UID do usuário.
 * @param {Array} params.items - Lista de itens para o pagamento.
 * @return {Promise<Object>} - Objeto do PaymentIntent criado.
 */
async function createStripePaymentIntent(
    stripeInstance, {
      totalAmount,
      userId,
      items,
    }) {
  if (!totalAmount || !userId || !items || items.length === 0) {
    throw new Error(
        "Missing or invalid parameters for creating PaymentIntent");
  }

  return stripeInstance.paymentIntents.create({
    amount: totalAmount,
    payment_method_types: ["card"],
    description: "Compra de produtos",
    currency: "brl",
    metadata: {
      userId,
      items: JSON.stringify(items),
    },
  });
}

module.exports = {createStripePaymentIntent};
