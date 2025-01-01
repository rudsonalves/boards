// Copyright (C) 2025 Rudson Alves
//
// This file is part of boards.
//
// boards is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// boards is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with boards.  If not, see <https://www.gnu.org/licenses/>.

// src/index.ts

import * as admin from "firebase-admin";

import { loadEnvIfLocal } from "./env.config";
loadEnvIfLocal();

admin.initializeApp();

// Importa as funções
import {
  assignDefaultUserRole,
} from "./auth/functions/assign_default_user_role";
import { changeUserRole } from "./auth/functions/change_user_role";

import { syncCreateBGNames } from "./boardgames/functions/sync_create_bg_bames";
import { syncDeleteBGName } from "./boardgames/functions/sync_delete_bg_name";
import { syncUpdateBGNames } from "./boardgames/functions/sync_update_bg_names";

import {
  notifySpecificUser,
} from "./notification/functions/notify_specific_user";

import { stripeWebhook } from "./stripe/webhook/functions/stripe_webhook";

import {
  createPaymentIntent,
} from "./stripe/payments/functions/create_payment_intent";
import {
  createCheckoutSession,
} from "./stripe/payments/functions/create_checkout_session";


// Exporta as funções
export {
  assignDefaultUserRole,
  changeUserRole,
  syncCreateBGNames,
  syncDeleteBGName,
  syncUpdateBGNames,
  notifySpecificUser,
  stripeWebhook,
  createPaymentIntent,
  createCheckoutSession,
};
