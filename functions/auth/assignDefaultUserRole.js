const {onCall} = require("firebase-functions/v2/https");
const {getAuth} = require("firebase-admin/auth");

const auth = getAuth();

/**
 * Atribui uma role padrão ao usuário autenticado.
 */
exports.assignDefaultUserRole = onCall(
    {
      region: "southamerica-east1",
    },
    async (request) => {
      try {
        console.log("Function assignDefaultUserRole called.");

        const context = request.auth;

        // Verificar se o usuário está autenticado
        if (!context) {
          console.error("User is not authenticated!");
          throw new Error("User must be authenticated to call this function.");
        }

        const userId = context.uid;
        if (!userId) {
          console.error("User ID not found in context.");
          throw new Error("Could not extract user ID from token");
        }

        // Definir o role como "user"
        const role = "user";

        // Se for a primeira configuração, descomente a linha abaixo para
        // definir como "admin"
        // const role = "admin";

        await auth.setCustomUserClaims(userId, {role});
        console.log(`Custom claims success => user: ${userId} role: ${role}`);

        return {
          message: `Custom claims success => user: ${userId} role: ${role}`,
        };
      } catch (error) {
        console.error("Error assigning default user role:", error);
        throw new Error("Failed to set custom claims");
      }
    },
);
