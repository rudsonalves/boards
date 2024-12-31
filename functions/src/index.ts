// src/index.ts

import * as admin from "firebase-admin";

import { loadEnvIfLocal } from "./env.config";
loadEnvIfLocal();

admin.initializeApp();

// Importa as funções
import { assignDefaultUserRole }
  from "./auth/functions/assign_default_user_role";
import { changeUserRole } from "./auth/functions/change_user_role";

import { syncCreateBGNames } from "./boardgames/functions/sync_create_bg_bames";
import { syncDeleteBGName } from "./boardgames/functions/sync_delete_bg_name";
import { syncUpdateBGNames } from "./boardgames/functions/sync_update_bg_names";

import { notifySpecificUser }
  from "./notification/functions/notify_specific_user";

import { stripeWebhook } from "./stripe/webhook/functions/stripe_webhook";


// Exporta as funções
export {
  assignDefaultUserRole,
  changeUserRole,
  syncCreateBGNames,
  syncDeleteBGName,
  syncUpdateBGNames,
  notifySpecificUser,
  stripeWebhook,
};
