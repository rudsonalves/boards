// src/functions/assignDefaultUserRole.ts

import {
  onCall,
  HttpsError,
} from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { getAuth } from "firebase-admin/auth";
import { verifyAuth } from "./utils/verifyAuth";

/**
 * Função para atribuir o papel padrão "user" a um usuário autenticado.
 *
 * @function assignDefaultUserRole
 * @param {unknown} data - Dados enviados pelo cliente (não utilizados).
 * @param {any} context - Contexto da invocação da função.
 * @return {Promise<{ message: string }>} - Mensagem de sucesso.
 * @throws {HttpsError} - Se o usuário não estiver autenticado ou ocorrer um
 *                        erro interno.
 */
export const assignDefaultUserRole = onCall(
  {
    region: "southamerica-east1",
  },
  async (request: any): Promise<{ message: string }> => {
    logger.info("<01> Function assignDefaultUserRole called.");

    try {
      // Verificar se o usuário está autenticado
      const userId = verifyAuth(request);

      // Definir o papel como "user"
      const role = "user";

      // Definir custom claims para o usuário
      const auth = getAuth();
      await auth.setCustomUserClaims(userId, { role });

      logger.info(`Custom claims success => user: ${userId}, role: ${role}`);

      return {
        message: `Custom claims success => user: ${userId}, role: ${role}`,
      };
    } catch (error: unknown) {
      const errorMessage = error instanceof Error ?
        error.message :
        "Unknown error occurred.";
      logger.error("Error assigning default user role.", { error });
      throw new HttpsError("internal", errorMessage);
    }
  }
);
