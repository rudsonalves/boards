// src/notification/interfaces/user_data.ts

/**
 * Interface dos campos esperados no documento do usuário
 * (users/{targetUserId}).
 */
export interface UserData {
  fcmToken?: string;
  title?: string;
  // ...adicione outros campos conforme necessário
}
