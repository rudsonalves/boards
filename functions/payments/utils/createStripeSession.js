const {initializeStripe} = require("./initializeStripe");

/**
 * Cria uma sessão de checkout no Stripe com base nos itens reservados.
 *
 * @async
 * @function createStripeSession
 * @param {Array} items - Lista de itens reservados para checkout, contendo
 *                        title e unit_price.
 * @param {string} userId - UID do usuário autenticado.
 * @return {Promise<string>} - Retorna a URL da sessão de checkout do Stripe.
 * @throws {HttpsError} - Caso a chave da API do Stripe não esteja configurada
 *                        ou haja falha na criação da sessão.
 */
async function createStripeSession(items, userId) {
  const now = Math.floor(Date.now() / 1000); // Tempo atual em segundos
  const expiresAt = now + 30 * 60; // 30 minutos em segundos
  const stripeInstance = initializeStripe();

  const lineItems = items.map((item) => ({
    price_data: {
      currency: "brl",
      product_data: {name: item.title},
      unit_amount: Math.round(item.unit_price * 100),
    },
    quantity: item.quantity,
  }));

  const session = await stripeInstance.checkout.sessions.create({
    payment_method_types: ["card", "boleto"],
    line_items: lineItems,
    mode: "payment",
    success_url: "https://rralves.dev.br/boards-pagamento-sucesso/",
    cancel_url: "https://rralves.dev.br/boards-pagamento-cancelado/",
    locale: "pt-BR",
    payment_method_options: {
      card: {
        installments: {enabled: true},
      },
    },
    metadata: {
      userId,
      items: JSON.stringify(items),
    },
    expires_at: expiresAt,
  });

  console.log("createStripeSession resolved");
  return session.url;
}

module.exports = {createStripeSession};
