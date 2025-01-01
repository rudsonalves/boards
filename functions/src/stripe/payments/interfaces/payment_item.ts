// src/stripe/payments/interfaces/payment_item.ts

/**
 * Representa um item de pagamento, contendo preço unitário e quantidade.
 */
export interface PaymentItem {
  adId: string;
  title: string;
  unit_price: number;
  quantity: number;
}

export interface PaymentData {
  totalAmount: number;
  userId: string;
  items: PaymentItem[];
}
