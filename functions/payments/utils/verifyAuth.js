/**
 * Verifica se o usuário está autenticado no contexto da requisição.
 *
 * @function verifyAuth
 * @param {Object} request - Objeto da requisição do Firebase Functions
 *                           (onCall).
 * @param {Object} request.auth - Contexto de autenticação do usuário.
 * @return {string} - Retorna o UID do usuário autenticado.
 * @throws {Error} - Caso não haja contexto de autenticação (usuário
 *                   não logado).
 */
function verifyAuth(request) {
  const auth = request.auth;
  if (!auth) {
    console.error("User is not authenticated!!!!!");
    throw new Error("User must be authenticated.");
  }
  console.log("User verified");
  return auth.uid;
}

module.exports = {verifyAuth};
