// src/notification/functions/notify_specific_user.ts

import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { logger } from "firebase-functions/v2";
import { getFirestore } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";

import { MessageData } from "../interfaces/message_data";
import { UserData } from "../interfaces/user_data";

/**
 * Notifica um usuário específico sobre uma nova mensagem adicionada a um
 * anúncio.
 */
export const notifySpecificUser = onDocumentCreated(
  {
    document: "ads/{adId}/messages/{messageId}",
    region: "southamerica-east1",
  },
  async (event) => {
    logger.info("Triggered notifySpecificUser");

    try {
      const snapshot = event.data;
      if (!snapshot) {
        logger.error("No document snapshot available.");
        return;
      }

      // Dados da nova mensagem
      const messageData = snapshot.data() as MessageData;
      const { adId } = event.params;
      const { targetUserId, senderName } = messageData;

      if (!targetUserId) {
        logger.error("No target userId found for notification.");
        return;
      }

      const firestore = getFirestore();
      const userDoc = await firestore
        .collection("users")
        .doc(targetUserId)
        .get();

      if (!userDoc.exists) {
        logger.error(`No user document found for userId: ${targetUserId}`);
        return;
      }

      // Dados do usuário alvo (que receberá a notificação)
      const userData = userDoc.data() as UserData;
      const { fcmToken, title: msgTitle } = userData;

      if (!fcmToken) {
        logger.error(`No FCM token found for userId: ${targetUserId}`);
        return;
      }

      const notification = {
        notification: {
          title: "Nova mensagem da Boards",
          body: `${senderName || "Alguém"} enviou/respondeu` +
            ` uma mensagem no anúncio "${msgTitle || "sem título"
            }".`,
        },
        token: fcmToken,
        data: {
          adId: adId,
        },
      };

      const messaging = getMessaging();
      await messaging.send(notification);

      logger.info(
        `Notification sent to userId: ${targetUserId},` +
        ` Ad: ${adId}, Title: ${msgTitle}`
      );
    } catch (error) {
      logger.error("Error sending notification:", error);
    }
  }
);
