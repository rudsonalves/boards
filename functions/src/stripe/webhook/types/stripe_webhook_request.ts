/**
 * Definimos um tipo para contemplar o `rawBody` usado no webhook.
 * Se estiver usando o Cloud Functions para HTTP, é comum ter `rawBody`
 * disponível na request. Certifique-se de que seu middleware está configurado
 * para manter o rawBody.
 */
export type StripeWebhookRequest = Request & {
  rawBody?: Buffer;
};
