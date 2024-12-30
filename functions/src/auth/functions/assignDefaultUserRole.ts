// src/auth/functions/assignDefaultUserRole.ts

import { onCall, CallableRequest } from "firebase-functions/v2/https";
import { getAuth } from "firebase-admin/auth";
import { logger } from "firebase-functions/v2";
import { verifyAuth } from "../utils/verifyAuth";

/**
 * Tipagem de possível resposta da função.
 * Ajuste conforme a necessidade.
 */
interface AssignDefaultUserRoleResponse {
  message: string;
}

/**
 * Atribui uma role padrão ao usuário autenticado.
 */
export const assignDefaultUserRole = onCall(
  {
    region: "southamerica-east1",
  },
  async (
    request: CallableRequest<unknown>,
  ): Promise<AssignDefaultUserRoleResponse> => {
    logger.info("Function assignDefaultUserRole called.");

    try {
      // Verificar se o usuário está autenticado
      const userId = verifyAuth(request);

      // Definir o role como "user"
      const role = "user";

      //  Definir custom claims para o usuário
      const auth = getAuth();
      await auth.setCustomUserClaims(userId, { role });

      logger.info(
        `Function assignDefaultUserRole completed for user: ${userId}.`,
      );

      return {
        message: `Custom claims success => user: ${userId} role: ${role}`,
      };
    } catch (error) {
      logger.error("Error assigning default user role:", error);
      throw new Error("Failed to set custom claims");
    }
  }
);
