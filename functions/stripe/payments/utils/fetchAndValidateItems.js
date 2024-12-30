/**
 * Valida e retorna os itens enviados na requisição.
 *
 * @function fetchAndValidateItems
 * @param {Object} request - Objeto da requisição Firebase Functions (onCall).
 * @return {Array} - Lista de itens validados.
 * @throws {Error} - Caso items não sejam encontrados ou não sejam um array
 *                   válido.
 */
function fetchAndValidateItems(request) {
  const items = request.items;

  if (!items || !Array.isArray(items)) {
    throw new Error("Items must be a valid array.");
  }

  return items;
}

module.exports = {fetchAndValidateItems};
