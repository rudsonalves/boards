// env.config.ts
import { logger } from "firebase-functions/v2";

/**
 * Carrega variáveis de ambiente a partir de um arquivo .env.local
 * apenas quando executado localmente (emulador de funções).
 *
 * @function loadEnvIfLocal
 * @description
 * Se a variável de ambiente `FUNCTIONS_EMULATOR` estiver definida,
 * carrega as variáveis de ambiente do arquivo `.env.local` usando
 * a biblioteca `dotenv`. Caso contrário (em produção), apenas registra
 * que as variáveis são carregadas como segredos do Firebase.
 *
 * @return {void} Esta função não retorna valor, apenas configura
 *                 variáveis de ambiente quando local.
 */
export function loadEnvIfLocal() {
  if (process.env.FUNCTIONS_EMULATOR) {
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    require("dotenv").config({ path: ".env.local" });
    logger.info("Loaded .env.local for development or testing.");
  } else {
    logger.info("Running in production. Using Firebase Secrets.");
  }
}
