/**
 * Inicializa a instância do Stripe usando as chaves de API apropriadas.
 *
 * @function initializeStripe
 * @param {string} stripeApiKey - The API key for Stripe.
 * @return {Object} - Instância do Stripe.
 */
function initializeStripe(stripeApiKey) {
  return require("stripe")(stripeApiKey);
}

module.exports = {initializeStripe};
