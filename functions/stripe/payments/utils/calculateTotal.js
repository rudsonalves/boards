/**
 * Calcula o valor total em centavos baseado nos itens fornecidos.
 *
 * @function calculateTotal
 * @param {Array} items - Lista de itens, cada um contendo unit_price e
 *                        quantity.
 * @return {number} - Valor total calculado em centavos.
 */
function calculateTotal(items) {
  if (!Array.isArray(items) || items.length === 0) {
    throw new Error("Invalid items array provided for calculateTotal");
  }

  return items.reduce((total, item) => {
    if (!item.unit_price || !item.quantity) {
      throw new Error("Each item must have a unit_price and quantity");
    }

    return total + Math.round(item.unit_price * 100) * item.quantity;
  }, 0);
}

module.exports = {calculateTotal};
