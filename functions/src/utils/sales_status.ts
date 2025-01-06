export const SALESTATUS = {
  PENDING: "pending", // Venda registrada, aguardando pagamento
  PAID: "paid", // Pagamento recebido, aguardando entrega
  DELIVERED: "delivered", // Produto entregue pelo vendedor
  CONFIRMEDDELIVERY: "confirmedDelivery", // Comprador confirmou a entrega
  INDISPUTE: "inDispute", // Disputa aberta pelo comprador
  ESCROW_HELD: "escrowHeld", // Pagamento retido em garantia (Escrow)
  RELEASED: "released", // Pagamento liberado ao vendedor
  REFUNDED: "refunded", // Reembolso processado
  CLOSED: "closed",
};
