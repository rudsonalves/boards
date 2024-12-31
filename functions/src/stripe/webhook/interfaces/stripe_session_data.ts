// src/stripe/webhook/interfaces/stripe_session_data.ts

/**
 * Representa os dados essenciais de uma sessão do Stripe,
 * contendo `metadata.items` (como JSON string) e `metadata.userId`.
 */
export interface StripeSessionData {
  id: string;
  metadata?: {
    items?: string;
    userId?: string;
  } | null;
}
