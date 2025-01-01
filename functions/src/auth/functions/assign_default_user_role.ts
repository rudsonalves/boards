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

// src/auth/functions/assign_default_user_role.ts

import { onCall, CallableRequest } from "firebase-functions/v2/https";
import { getAuth } from "firebase-admin/auth";
import { logger } from "firebase-functions/v2";
import { verifyAuth } from "../utils/verify_auth";

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
