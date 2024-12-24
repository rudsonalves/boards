// src/message/utils/getUserData.ts

import { getFirestore } from "firebase-admin/firestore";

/* eslint-disable valid-jsdoc */
/**
 * Obtém os dados do usuário do Firestore.
 * @param {string} userId - O ID do usuário a ser buscado.
 * @returns {Promise<{ fcmToken?: string; title?: string }>} Os dados do
 *                    usuário, incluindo o token FCM e o título do anúncio.
 * @throws {Error} Se o documento do usuário não existir.
 */
export async function getUserData(
  userId: string,
): Promise<{ fcmToken?: string; title?: string }> {
  const firestore = getFirestore();
  const userDoc = await firestore.collection("users").doc(userId).get();

  if (!userDoc.exists) {
    throw new Error(`No user document found for userId: ${userId}`);
  }

  return userDoc.data() as { fcmToken?: string; title?: string };
}
