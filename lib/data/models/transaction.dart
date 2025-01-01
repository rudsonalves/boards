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

enum TransType { deposit, withdraw, refund, purchase, adjustment }

enum TransPayMethod { pix, bill, creditCard, debitCard }

enum TransStatus { pending, completed, failed, canceled }

class TransactionModel {
  String? id;
  TransType type;
  TransStatus status;
  TransPayMethod payMethod;
  double amount;
  String userId;
  String description;
  DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.type,
    required this.status,
    required this.payMethod,
    required this.amount,
    required this.userId,
    required this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  TransactionModel copyWith({
    String? id,
    TransType? type,
    TransStatus? status,
    TransPayMethod? payMethod,
    double? amount,
    String? userId,
    String? description,
    DateTime? createdAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      payMethod: payMethod ?? this.payMethod,
      amount: amount ?? this.amount,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
