// src/index.ts

import * as admin from "firebase-admin";

import { assignDefaultUserRole } from "./auth/functions/assignDefaultUserRole";
import { changeUserRole } from "./auth/functions/changeUserRole";

import { notifySpecificUser } from "./message/functions/notifySpecificUser";

import { deleteBGName } from "./bgnames/functions/deleteBGName";
import { syncCreateBGNames } from "./bgnames/functions/syncCreateBGNames";

// Inicializa o Admin SDK
if (admin.apps.length === 0) {
  admin.initializeApp();
}

// Outras funções podem ser importadas aqui
export {
  assignDefaultUserRole,
  changeUserRole,
  notifySpecificUser,
  syncCreateBGNames,
  deleteBGName,
};
