// Copyright (C) 2025 Rudson Alves
//
// This file is part of boards.
//
// boards is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// boards is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with boards.  If not, see <https://www.gnu.org/licenses/>.

/**
 * Representa um item de pagamento, contendo preço unitário e quantidade.
 */
export interface IItem {
  adId: string;
  title: string;
  unit_price: number;
  quantity: number;
}

/**
 * Representa os dados de uma compra, usado para receber dados do frontend.
 */
export interface PaymentData {
  buyerId: string;
  sellerId: string;
  items: IItem[];
}

/**
 * Representa os dados de uma compra, usado para passar dados entre funções. O
 * totalAmount é calculado internamente, verificando os preços no firestore.
 */
export interface PaymentItems {
  buyerId: string;
  sellerId: string;
  totalAmount: number;
  items: IItem[];
}
