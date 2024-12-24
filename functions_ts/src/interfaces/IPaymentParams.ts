// src/interfaces/IPaymentParams.ts

import { IItem } from "./IItem";

/**
 * Estrutura de parâmetros necessários para criar um PaymentIntent.
 */
export interface IPaymentParams {
  /**
   * Valor total da compra em centavos (e.g., 1000 para R$10,00).
   */
  totalAmount: number;

  /**
   * UID do usuário que está realizando o pagamento.
   */
  userId: string;

  /**
   * Lista de itens para o pagamento (pode ser tipada de forma mais
   * específica conforme sua estrutura).
   */
  items: Array<IItem>;
}
