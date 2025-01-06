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

// src/functions/utils/verify_auth.ts

import { CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";

/**
 * Verifica se o usuário está autenticado no contexto da requisição.
 *
 * @function verifyAuth
 * @param {any} request - Objeto da requisição do Firebase Functions (onCall).
 * @return {string} - Retorna o UID do usuário autenticado ou null caso
 *                           não esteja autenticado.
 */
export function verifyAuth(request: CallableRequest<unknown>): string {
  if (!request.auth) {
    logger.error("verifyAuth: Authentication context is missing.");
    throw new HttpsError("unauthenticated",
      "Authentication context is missing.");
  }

  const uid = request.auth.uid;
  if (!uid) {
    logger.error("verifyAuth: UID is missing in authentication context.",
      { auth: request.auth });
    throw new HttpsError("unauthenticated",
      "User is not logged in.");
  }

  logger.info("verifyAuth: User is authenticated.", { uid });
  return uid;
}
