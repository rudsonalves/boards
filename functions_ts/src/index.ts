// src/index.ts

import * as admin from "firebase-admin";
import dotenv from "dotenv";

// Se estiver usando ESLint, pode ser que exija "import" em vez de "require".
// Mas se quiser carregar `.env` dinamicamente só fora do ambiente de produção,
// a forma abaixo (require) costuma ser aceita.
if (process.env.NODE_ENV !== "production") {
  dotenv.config({ path: ".env.local" });
}

// Inicializa o Admin SDK (após carregar env, se quiser usar variáveis .env em
// algum config)
if (admin.apps.length === 0) {
  admin.initializeApp();
}

import { assignDefaultUserRole } from "./auth/functions/assignDefaultUserRole";
import { changeUserRole } from "./auth/functions/changeUserRole";

import { notifySpecificUser } from "./message/functions/notifySpecificUser";

import { syncDeleteBGName } from "./bgnames/functions/syncDeleteBGName";
import { syncCreateBGName } from "./bgnames/functions/syncCreateBGName";

import { stripeWebhook } from "./webhook/functions/stripeWebhook";

// import { createPaymentIntent }
// from "./payment/functions/createPaymentIntent";
// import { createCheckoutSession }
// from "./payment/functions/createCheckoutSession";


// Outras funções podem ser importadas aqui
export {
  assignDefaultUserRole,
  changeUserRole,
  notifySpecificUser,
  syncCreateBGName,
  syncDeleteBGName,
  stripeWebhook,
  // createPaymentIntent,
  // createCheckoutSession,
};
