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

// ignore_for_file: public_member_api_docs, sort_constructors_first

enum UserRole { user, admin }

class UserModel {
  String? id;
  String? name;
  String email;
  bool isEmailVerified;
  String? phone;
  bool isPhoneVerified;
  String? password;
  UserRole role;
  int sales;
  int points;
  String? fcmToken;
  DateTime? createdAt;

  UserModel({
    this.id,
    this.name,
    required this.email,
    this.isEmailVerified = false,
    this.phone,
    this.isPhoneVerified = false,
    this.password,
    DateTime? createdAt,
    this.role = UserRole.user,
    this.sales = 0,
    this.points = 0,
    this.fcmToken,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  String toString() {
    return 'User(id: $id,'
        ' name: $name,'
        ' email: $email (verified: $isEmailVerified),'
        ' phone: $phone (verified: $isPhoneVerified),'
        ' password: $password,'
        ' role: ${role.name},'
        ' sales: $sales,'
        ' points: $points,'
        ' token: $fcmToken,'
        ' createdAt: $createdAt';
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? isEmailVerified,
    String? phone,
    bool? isPhoneVerified,
    String? password,
    UserRole? role,
    int? sales,
    int? points,
    String? fcmToken,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      phone: phone ?? this.phone,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      role: role ?? this.role,
      sales: sales ?? this.sales,
      points: points ?? this.points,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
