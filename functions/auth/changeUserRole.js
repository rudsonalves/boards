const {onCall} = require("firebase-functions/v2/https");
const {getAuth} = require("firebase-admin/auth");

const auth = getAuth();

/**
 * Permite que um administrador altere o papel de outro usuário.
 */
exports.changeUserRole = onCall(
    {
      region: "southamerica-east1",
    },
    async (request) => {
      try {
        const context = request.auth;

        // Verificar se o usuário está autenticado
        if (!context) {
          throw new Error("User must be authenticated to call this function.");
        }

        // Verificar se o usuário é admin
        const currentUserClaims = context.token;
        if (!currentUserClaims.role || currentUserClaims.role !== "admin") {
          throw new Error(
              "Permission denied: only admin can change user roles",
          );
        }

        // Extrair payload
        const {userId, role} = request.data;

        if (!userId || !role) {
          throw new Error("Missing userId or role parameter");
        }

        // Atualizar o role do usuário
        await auth.setCustomUserClaims(userId, {role});
        console.log(
            `Custom claims success => user: ${userId} role: ${role}`,
        );

        return {
          message: `Custom claims success => user: ${userId} role: ${role}`,
        };
      } catch (error) {
        console.error("Error changing user role:", error);
        throw new Error("Failed to set custom claims");
      }
    },
);
