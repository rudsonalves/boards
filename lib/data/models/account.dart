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

class AccountModel {
  String? id;
  double balance;
  double blockedBalance;
  String pixKey;
  String accountId;
  DateTime createdAt;
  DateTime updatedAt;

  AccountModel({
    this.id,
    required this.balance,
    required this.blockedBalance,
    required this.pixKey,
    required this.accountId,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  AccountModel copyWith({
    String? id,
    double? balance,
    double? blockedBalance,
    String? pixKey,
    String? accountId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountModel(
      id: id ?? this.id,
      balance: balance ?? this.balance,
      blockedBalance: blockedBalance ?? this.blockedBalance,
      pixKey: pixKey ?? this.pixKey,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
