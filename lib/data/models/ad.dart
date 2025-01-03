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

import '../../core/utils/extensions.dart';
import '../../logic/managers/mechanics_manager.dart';
import '../../core/get_it.dart';

enum AdStatus { pending, active, sold, deleted, reserved }

enum ProductCondition { all, used, sealed }

class AdModel {
  String? id;
  String? ownerId;
  String? ownerName;
  double? ownerScore;
  String? ownerCity;
  String? ownerState;
  DateTime? ownerCreateAt;
  String title;
  String description;
  double price;
  int quantity;
  AdStatus status;
  List<String> mechanicsIds;
  List<String> images;
  ProductCondition condition;
  String? boardgameId;
  int views;
  DateTime createdAt;

  AdModel({
    this.id,
    this.ownerId,
    this.ownerName,
    this.ownerScore,
    this.ownerCity,
    this.ownerState,
    this.ownerCreateAt,
    required this.images,
    required this.title,
    required this.description,
    required this.mechanicsIds,
    required this.price,
    this.quantity = 1,
    this.condition = ProductCondition.used,
    this.status = AdStatus.pending,
    this.views = 0,
    this.boardgameId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get mechanicsString {
    final mechManager = getIt<MechanicsManager>();
    return mechManager.mechanics
        .where((mec) => mechanicsIds.contains(mec.id))
        .map((mec) => mec.name)
        .toList()
        .join(', ');
  }

  String? get singleAddressString => ownerCity != null && ownerState != null
      ? '$ownerCity - $ownerState'
      : null;

  AdModel copyWith({
    String? id,
    String? ownerId,
    String? ownerName,
    double? ownerScore,
    String? ownerCity,
    String? ownerState,
    DateTime? ownerCreateAt,
    String? title,
    String? description,
    double? price,
    int? quantity,
    AdStatus? status,
    List<String>? mechanicsIds,
    List<String>? images,
    ProductCondition? condition,
    String? boardgameId,
    int? views,
    DateTime? createdAt,
  }) {
    return AdModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerScore: ownerScore ?? this.ownerScore,
      ownerCity: ownerCity ?? this.ownerCity,
      ownerState: ownerState ?? this.ownerState,
      ownerCreateAt: ownerCreateAt ?? this.ownerCreateAt,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      mechanicsIds: mechanicsIds ?? this.mechanicsIds,
      images: images ?? this.images,
      condition: condition ?? this.condition,
      boardgameId: boardgameId ?? this.boardgameId,
      views: views ?? this.views,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerScore': ownerScore,
      'ownerCity': ownerCity,
      'ownerState': ownerState,
      'ownerCreateAt': ownerCreateAt?.millisecondsSinceEpoch,
      'title': title,
      'description': description,
      'price': price,
      'quantity': quantity,
      'status': status.name,
      'mechanicsIds': mechanicsIds,
      'images': images,
      'condition': condition.name,
      'boardgame': boardgameId,
      'views': views,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory AdModel.fromMap(Map<String, dynamic> map) {
    return AdModel(
      id: map['id'] != null ? map['id'] as String : null,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      ownerName: map['ownerName'] != null ? map['ownerName'] as String : null,
      ownerScore:
          map['ownerScore'] != null ? map['ownerScore'] as double : null,
      ownerCity: map['ownerCity'] != null ? map['ownerCity'] as String : null,
      ownerState:
          map['ownerState'] != null ? map['ownerState'] as String : null,
      ownerCreateAt: map['ownerCreateAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['ownerCreateAt'] as int)
          : null,
      title: map['title'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      status: AdStatus.values.fromName(map['status'] as String),
      mechanicsIds: List<String>.from((map['mechanicsIds'] as List<dynamic>)
          .map((item) => item.toString())),
      images: List<String>.from(
          (map['images'] as List<dynamic>).map((item) => item.toString())),
      condition: map['condition'] != null
          ? ProductCondition.values.fromName(map['condition'] as String)
          : ProductCondition.used,
      boardgameId: map['boardgame'] as String?,
      views: map['views'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }
}
