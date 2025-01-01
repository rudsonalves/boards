// src/stripe/payments/interfaces/reserve_date.ts

/**
 * Interface para cada item que será reservado.
 */
export interface ReserveData {
  quantity: number;
  reservedUntil: Date;
}

