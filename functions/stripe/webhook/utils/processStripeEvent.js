const {handlePaymentSuccess} = require("./handlePaymentSuccess");
const {handlePaymentFailure} = require("./handlePaymentFailure");

/**
 * Processa o evento do Stripe baseado no tipo.
 *
 * @async
 * @function processStripeEvent
 * @param {Object} event - Evento validado do Stripe.
 */
async function processStripeEvent(event) {
  switch (event.type) {
    case "checkout.session.completed": {
      await handlePaymentSuccess(event.data.object);
      console.log(`Webhook evento: ${event.type}`);
      break;
    }

    case "checkout.session.expired":
    case "checkout.session.async_payment_failed": {
      await handlePaymentFailure(event.data.object);
      console.log(`Session payment event: ${event.type}`);
      break;
    }

    default: {
      console.log(`Evento não tratado: ${event.type}`);
      break;
    }
  }
}

module.exports = {processStripeEvent};
