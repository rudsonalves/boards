// src/message/functions/notifySpecificUser.ts

import { logger } from "firebase-functions/v2";
import { onDocumentCreated } from "firebase-functions/v2/firestore";

import { sendNotification } from "../utils/sendNotification";
import { getUserData } from "../utils/getUserData";

/**
 * Notifica um usuário específico sobre uma nova mensagem adicionada a
 * um anúncio.
 *
 * @function notifySpecificUser
 * @param {Object} event - Evento Firestore onDocumentCreated.
 * @param {Object} event.data - Documento criado no Firestore.
 * @param {Object} event.params - Parâmetros da rota, incluindo adId e
 *                                messageId.
 * @description
 * Ao criar um novo documento em "ads/{adId}/messages/{messageId}", esta função:
 * 1. Obtém dados do destinatário da mensagem (targetUserId).
 * 2. Busca o token FCM do usuário.
 * 3. Envia uma notificação push informando sobre a nova mensagem.
 *
 * @throws {Error} - Caso não exista documento do usuário ou FCM token.
 */
export const notifySpecificUser = onDocumentCreated(
  {
    document: "ads/{adId}/messages/{messageId}",
    region: "southamerica-east1",
  },
  async (event) => {
    logger.info("Notification trigger fired.");

    try {
      const snapshot = event.data; // Documento criado
      if (!snapshot) {
        logger.error("No document snapshot available.");
        return;
      }

      const messageData = snapshot.data();
      const { adId } = event.params; // Parâmetros da rota
      const targetUserId = messageData.targetUserId;

      if (!targetUserId) {
        logger.error("No target userId found for notification.");
        return;
      }

      const { fcmToken, title: msgTitle } = await getUserData(targetUserId);
      if (!fcmToken) {
        logger.error(`No FCM token found for userId: ${targetUserId}`);
        return;
      }

      // Configurar e enviar a notificação
      const msg = `enviou/respondeu uma mensagem no anúncio ${msgTitle}`;
      await sendNotification({
        title: "Nova mensagem da Boards",
        body: `${messageData.senderName || "Alguém"} ${msg}.`,
        token: fcmToken,
        data: { adId },
      });

      logger.info(`Notification sent to userId: 
        ${targetUserId}, Ad: ${adId}, Title: ${msgTitle}`);
    } catch (error) {
      logger.error("Error sending notification:", error);
    }
  }
);
