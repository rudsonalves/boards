const admin = require("firebase-admin");
const {logger} = require("firebase-functions/v2");

// Carrega as variáveis de ambiente do arquivo .env.local
if (process.env.FUNCTIONS_EMULATOR) {
  require("dotenv").config({path: ".env.local"});
  logger.info("Loaded .env.local for development or testing.");
} else {
  logger.info("Running in production. Using Firebase Secrets.");
}

// Inicialize o Firebase Admin SDK
admin.initializeApp();

const {notifySpecificUser} = require("./notification/notifySpecificUser");

const {syncCreateBGNames} = require("./boardgames/syncCreateBGNames");
const {syncDeleteBGName} = require("./boardgames/syncDeleteBGName");
const {syncUpdateBGNames} = require("./boardgames/syncUpdateBGNames");

const {assignDefaultUserRole} = require("./auth/assignDefaultUserRole");
const {changeUserRole} = require("./auth/changeUserRole");

const {createPaymentIntent} = require("./stripe/payments/createPaymentIntent");
const {createCheckoutSession} =
  require("./stripe/payments/createCheckoutSession");

const {stripeWebhook} = require("./stripe/webhook/stripeWebhook");

exports.notifySpecificUser = notifySpecificUser;

exports.syncCreateBGNames = syncCreateBGNames;
exports.syncDeleteBGName = syncDeleteBGName;
exports.syncUpdateBGNames = syncUpdateBGNames;

exports.assignDefaultUserRole = assignDefaultUserRole;
exports.changeUserRole = changeUserRole;

exports.createPaymentIntent = createPaymentIntent;
exports.createCheckoutSession = createCheckoutSession;

exports.stripeWebhook = stripeWebhook;
