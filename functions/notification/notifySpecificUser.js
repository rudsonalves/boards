const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {getFirestore} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");

/**
 * Notifica um usuário específico sobre uma nova mensagem adicionada a um
 * anúncio.
 */
exports.notifySpecificUser = onDocumentCreated(
    {
      document: "ads/{adId}/messages/{messageId}",
      region: "southamerica-east1",
    },
    async (event) => {
      try {
        const snapshot = event.data;
        if (!snapshot) {
          console.error("No document snapshot available.");
          return;
        }

        const messageData = snapshot.data();
        const {adId} = event.params;
        const {targetUserId, senderName} = messageData;

        if (!targetUserId) {
          console.error("No target userId found for notification.");
          return;
        }

        const firestore = getFirestore();
        const userDoc = await firestore
            .collection("users")
            .doc(targetUserId)
            .get();

        if (!userDoc.exists) {
          console.error(`No user document found for userId: ${targetUserId}`);
          return;
        }

        const userData = userDoc.data();
        const {fcmToken, title: msgTitle} = userData;

        if (!fcmToken) {
          console.error(`No FCM token found for userId: ${targetUserId}`);
          return;
        }

        const notification = {
          notification: {
            title: "Nova mensagem da Boards",
            body: `${senderName || "Alguém"} enviou/respondeu uma `+
          `mensagem no anúncio "${msgTitle || "sem título"}".`,
          },
          token: fcmToken,
          data: {
            adId: adId,
          },
        };

        const messaging = getMessaging();
        await messaging.send(notification);

        console.log(`Notification sent to userId: ${targetUserId}, `+
        `Ad: ${adId}, Title: ${msgTitle}`);
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    },
);
