// src/interfaces/IItem.ts

export interface IItem {
  adId: string; // ID do anúncio (ad) que o usuário quer reservar.
  title: string; // Título do item.
  quantity: number; // Quantidade desejada deste item.
  unit_price: number; // Preço unitário.
}
