/**
 * Valida o evento recebido do Stripe usando o webhook secret.
 *
 * @function validateWebhook
 * @param {Object} request - Objeto de requisição HTTP.
 * @param {Object} stripeInstance - Instância do Stripe.
 * @return {Object} - Evento validado do Stripe.
 */
function validateWebhook(request, stripeInstance) {
  const endpointSecret = process.env.WEBHOOK_SEC;

  if (!endpointSecret) {
    console.error("WEBHOOK_SEC is not defined.");
    throw new Error("Webhook secret not configured.");
  }

  const sig = request.headers["stripe-signature"];

  if (!request.rawBody || !(request.rawBody instanceof Buffer)) {
    throw new Error("rawBody is missing or not a Buffer.");
  }

  try {
    return stripeInstance.webhooks.constructEvent(
        request.rawBody,
        sig,
        endpointSecret,
    );
  } catch (err) {
    console.error("Erro ao validar webhook:", err.message);
    throw new Error(`Erro ao validar webhook: ${err.message}`);
  }
}

module.exports = {validateWebhook};
