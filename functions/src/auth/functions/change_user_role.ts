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

// src/auth/functions/change_user_role.ts

import { onCall, CallableRequest } from "firebase-functions/v2/https";
import { getAuth } from "firebase-admin/auth";
import { logger } from "firebase-functions/v2";

/**
 * Define o formato esperado no `request.data`.
 */
interface ChangeUserRoleRequest {
  userId: string;
  role: string;
}

/**
 * Define o formato do objeto de resposta da função.
 */
interface ChangeUserRoleResponse {
  message: string;
}

/**
 * Permite que um administrador altere o papel de outro usuário.
 */
export const changeUserRole = onCall(
  {
    region: "southamerica-east1",
  },
  async (
    request: CallableRequest<ChangeUserRoleRequest>,
  ): Promise<ChangeUserRoleResponse> => {
    logger.info("Function changeUserRole called.");

    try {
      const authData = request.auth;

      // Verificar se o usuário está autenticado
      if (!authData) {
        throw new Error("User must be authenticated to call this function.");
      }

      // Verificar se o usuário é admin
      const currentUserClaims = authData.token;
      if (!currentUserClaims.role || currentUserClaims.role !== "admin") {
        throw new Error("Permission denied: only admin can change user roles");
      }

      // Extrair payload
      const { userId, role } = request.data;
      if (!userId || !role) {
        throw new Error("Missing userId or role parameter");
      }

      // Atualizar o role do usuário
      const auth = getAuth();
      await auth.setCustomUserClaims(userId, { role });

      logger.info(`Custom claims success => user: ${userId} role: ${role}`);

      return {
        message: `Custom claims success => user: ${userId} role: ${role}`,
      };
    } catch (error) {
      logger.error("Error changing user role:", error);
      throw new Error("Failed to set custom claims");
    }
  }
);
