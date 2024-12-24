// src/functions/utils/verifyAuth.ts

import { HttpsError } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";

/**
 * Verifica se o usuário está autenticado no contexto da requisição.
 *
 * @function verifyAuth
 * @param {any} request - Objeto da requisição do Firebase Functions (onCall).
 * @return {string} - Retorna o UID do usuário autenticado.
 * @return {string | null} - Retorna o UID do usuário autenticado ou null caso
 *                           não esteja autenticado.
 */
export function verifyAuth(request: any): string {
  if (!request.auth) {
    logger.error("verifyAuth: Authentication context is missing.");
    throw new HttpsError("unauthenticated",
      "Authentication context is missing.");
  }

  const { uid } = request.auth;
  if (!uid) {
    logger.error("verifyAuth: UID is missing in authentication context.",
      { auth: request.auth });
    throw new HttpsError("unauthenticated",
      "User is not logged in.");
  }

  logger.info("verifyAuth: User is authenticated.", { uid });
  return uid;
}

