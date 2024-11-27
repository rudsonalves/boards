// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddressModel {
  String? id;
  String name;
  String zipCode;
  String userId;
  String street;
  String number;
  String? complement;
  String neighborhood;
  String state;
  String city;
  DateTime createdAt;

  AddressModel({
    this.id,
    required this.name,
    required this.zipCode,
    required this.userId,
    required this.street,
    required this.number,
    this.complement,
    required this.neighborhood,
    required this.state,
    required this.city,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String addressString() {
    return '$street, '
        'N° $number, '
        '${complement != null && complement!.isNotEmpty ? 'Complemento $complement, ' : ''}'
        'Bairro $neighborhood, '
        '$city - $state, '
        'CEP: $zipCode';
  }

  @override
  String toString() {
    return 'AddressModel(id: $id, name: $name, zipCode: $zipCode, userId: $userId, street: $street, number: $number, complement: $complement, neighborhood: $neighborhood, state: $state, city: $city, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.zipCode == zipCode &&
        other.userId == userId &&
        other.street == street &&
        other.number == number &&
        other.complement == complement &&
        other.neighborhood == neighborhood &&
        other.state == state &&
        other.city == city &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        zipCode.hashCode ^
        userId.hashCode ^
        street.hashCode ^
        number.hashCode ^
        complement.hashCode ^
        neighborhood.hashCode ^
        state.hashCode ^
        city.hashCode ^
        createdAt.hashCode;
  }

  AddressModel copyWith({
    String? id,
    String? name,
    String? zipCode,
    String? userId,
    String? street,
    String? number,
    String? complement,
    String? neighborhood,
    String? state,
    String? city,
    DateTime? createdAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      name: name ?? this.name,
      zipCode: zipCode ?? this.zipCode,
      userId: userId ?? this.userId,
      street: street ?? this.street,
      number: number ?? this.number,
      complement: complement ?? this.complement,
      neighborhood: neighborhood ?? this.neighborhood,
      state: state ?? this.state,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'zipCode': zipCode,
      'userId': userId,
      'street': street,
      'number': number,
      'complement': complement,
      'neighborhood': neighborhood,
      'state': state,
      'city': city,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      zipCode: map['zipCode'] as String,
      userId: map['userId'] as String,
      street: map['street'] as String,
      number: map['number'] as String,
      complement:
          map['complement'] != null ? map['complement'] as String : null,
      neighborhood: map['neighborhood'] as String,
      state: map['state'] as String,
      city: map['city'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
