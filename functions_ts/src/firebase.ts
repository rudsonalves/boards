// src/firebase.ts

import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";

// Inicializa o app apenas uma vez
initializeApp();

// Exporta o Firestore para reutilizar
export const firestore = getFirestore();
