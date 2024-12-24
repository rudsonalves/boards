// src/auth/functions/changeUserRole.ts

import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getAuth } from "firebase-admin/auth";
import { logger } from "firebase-functions/v2";

/**
 * Altera a função (role) de um usuário, requerendo que o chamador seja um
 * "admin".
 *
 * @function changeUserRole
 * @param {Object} request - Objeto da requisição onCall do Firebase Functions.
 * @param {Object} request.data - Dados da requisição, incluindo:
 *   @param {string} request.data.userId - UID do usuário cujo role será
 *                                         alterado.
 *   @param {string} request.data.role - Novo role a ser atribuído.
 * @param {Object} request.auth - Contexto de autenticação do usuário chamador.
 * @return {Promise<{ message: string }>} - Retorna um objeto com uma mensagem
 *                                          de sucesso.
 * @throws {HttpsError} - Caso o chamador não esteja autenticado, não seja
 *                        admin, ou faltem parâmetros.
 */
export const changeUserRole = onCall(
  {
    region: "southamerica-east1",
  },
  async (request): Promise<{ message: string }> => {
    const auth = getAuth();

    try {
      const context = request.auth;

      // Verificar se o usuário está autenticado
      if (!context) {
        logger.error("Authentication required to call changeUserRole.");
        throw new HttpsError(
          "unauthenticated",
          "User must be authenticated to call this function."
        );
      }

      // Verificar se o usuário é admin
      const currentUserClaims = context.token;
      if (currentUserClaims.role !== "admin") {
        logger.error("Permission denied: Only admin can change user roles.");
        throw new HttpsError(
          "permission-denied",
          "Only admin can change user roles."
        );
      }

      // Extrair payload
      const { userId, role } = request.data;
      if (!userId || !role) {
        logger.error("Missing userId or role in the request payload.");
        throw new HttpsError(
          "invalid-argument",
          "Both userId and role parameters are required."
        );
      }

      // Atualizar o role do usuário
      await auth.setCustomUserClaims(userId, { role });
      const mesg = "Custom claims updated successfully => " +
        `user: ${userId}, role: ${role}`;
      logger.info(mesg);

      return { message: mesg };
    } catch (error) {
      logger.error("Error changing user role:", error);
      if (error instanceof HttpsError) {
        throw error;
      }
      throw new HttpsError("internal", "Failed to change user role.");
    }
  }
);
