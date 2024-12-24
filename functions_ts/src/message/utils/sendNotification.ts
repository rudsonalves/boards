// src/message/utils/sendNotification.ts

import { getMessaging } from "firebase-admin/messaging";

/**
 * Envia uma notificação push via Firebase Cloud Messaging.
 * @param {Object} notification - Objeto de configuração da notificação.
 * @param {string} notification.title - Título da notificação.
 * @param {string} notification.body - Corpo da notificação.
 * @param {string} notification.token - Token FCM do destinatário.
 * @param {Record<string, string>} notification.data - Dados adicionais para a
 *                                                     notificação.
 */
export async function sendNotification(notification: {
  title: string;
  body: string;
  token: string;
  data: Record<string, string>;
}): Promise<void> {
  const messaging = getMessaging();
  await messaging.send({
    notification: {
      title: notification.title,
      body: notification.body,
    },
    token: notification.token,
    data: notification.data,
  });
}
