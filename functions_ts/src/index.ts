// src/index.ts

import * as admin from "firebase-admin";

import { assignDefaultUserRole } from "./functions/assignDefaultUserRole";

// Inicializa o Admin SDK
if (admin.apps.length === 0) {
  admin.initializeApp();
}

// Outras funções podem ser importadas aqui
export {
  assignDefaultUserRole,
};
