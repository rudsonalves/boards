// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import '../../data_managers/mechanics_manager.dart';
import '../../get_it.dart';
import 'address.dart';
import 'boardgame.dart';
import 'user.dart';

enum AdStatus { pending, active, sold, deleted }

enum ProductCondition { all, used, sealed }

class AdModel {
  String? id;
  UserModel? owner;
  String? ownerId;
  String? ownerName;
  double? ownerRate;
  String? ownerCity;
  DateTime? ownerCreateAt;
  String title;
  String description;
  double price;
  int quantity;
  AdStatus status;
  List<String> mechanicsIds;
  AddressModel? address;
  List<String> images;
  ProductCondition condition;
  BoardgameModel? boardgame;
  int views;
  DateTime createdAt;

  AdModel({
    this.id,
    this.owner,
    this.ownerId,
    this.ownerName,
    this.ownerRate,
    this.ownerCity,
    this.ownerCreateAt,
    required this.images,
    required this.title,
    required this.description,
    required this.mechanicsIds,
    this.address,
    required this.price,
    this.quantity = 1,
    this.condition = ProductCondition.used,
    this.status = AdStatus.pending,
    this.views = 0,
    this.boardgame,
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

  @override
  String toString() {
    return 'AdModel(id: $id,\n'
        ' owner: $owner,\n'
        ' title: $title,\n'
        ' description: $description,\n'
        ' price: $price,\n'
        ' quantity: $quantity,\n'
        ' status: $status,\n'
        ' mechanicsIds: $mechanicsIds,\n'
        ' address: $address,\n'
        ' images: $images,\n'
        ' condition: $condition,\n'
        ' views: $views,\n'
        ' createdAt: $createdAt)';
  }

  AdModel copyWith({
    String? id,
    UserModel? owner,
    String? ownerId,
    String? ownerName,
    double? ownerRate,
    String? ownerCity,
    DateTime? ownerCreateAt,
    String? title,
    String? description,
    double? price,
    int? quantity,
    AdStatus? status,
    List<String>? mechanicsIds,
    AddressModel? address,
    List<String>? images,
    ProductCondition? condition,
    int? views,
    DateTime? createdAt,
  }) {
    return AdModel(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerRate: ownerRate ?? this.ownerRate,
      ownerCity: ownerCity ?? this.ownerCity,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      mechanicsIds: mechanicsIds ?? this.mechanicsIds,
      address: address ?? this.address,
      images: images ?? this.images,
      condition: condition ?? this.condition,
      views: views ?? this.views,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'owner': owner?.id,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerRate': ownerRate,
      'ownerCity': ownerCity,
      'ownerCreateAt': ownerCreateAt,
      'title': title,
      'description': description,
      'price': price,
      'quantity': quantity,
      'status': status.index,
      'mechanicsIds': mechanicsIds,
      'address': address?.toMap(),
      'images': images,
      'condition': condition.index,
      'boardgame': boardgame?.id,
      'views': views,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory AdModel.fromMap(Map<String, dynamic> map) {
    return AdModel(
      id: map['id'] != null ? map['id'] as String : null,
      owner: null,
      ownerId: map['ownerId'],
      ownerName: map['ownerName'],
      ownerRate: map['ownerRate'],
      ownerCity: map['ownerCity'],
      ownerCreateAt: map['ownerCreateAt'],
      title: map['title'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      status: AdStatus.values[map['status'] as int],
      mechanicsIds: List<String>.from(map['mechanicsIds'] as List<String>),
      address: null,
      images: List<String>.from(map['images'] as List<String>),
      condition: ProductCondition.values[map['condition'] as int],
      boardgame: null,
      views: map['views'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory AdModel.fromJson(String source) =>
      AdModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
