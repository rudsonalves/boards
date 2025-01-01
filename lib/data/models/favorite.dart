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

class FavoriteModel {
  final String? id;
  final String userId;
  final String adId;

  FavoriteModel({
    this.id,
    required this.adId,
    required this.userId,
  });

  FavoriteModel copyWith({
    String? id,
    String? adId,
    String? userId,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      adId: adId ?? this.adId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'adId': adId,
      'userId': userId,
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'] != null ? map['id'] as String : null,
      adId: map['adId'] as String,
      userId: map['userId'] as String,
    );
  }

  @override
  String toString() => 'FavoriteModel(id: $id, adId: $adId, userId: $userId)';
}
