// src/index.ts

import * as admin from "firebase-admin";
import { logger } from "firebase-functions/v2";

if (process.env.FUNCTIONS_EMULATOR) {
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  require("dotenv").config({ path: ".env.local" });
  logger.info("Loaded .env.local for development or testing.");
} else {
  logger.info("Running in production. Using Firebase Secrets.");
}

admin.initializeApp();

// Importa as funções
import { assignDefaultUserRole } from "./auth/functions/assignDefaultUserRole";


// Exporta as funções
export {
  assignDefaultUserRole,
};
