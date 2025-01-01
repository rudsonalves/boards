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

class AddressModel {
  String? id;
  bool selected;
  String name;
  String zipCode;
  String street;
  String number;
  String? complement;
  String neighborhood;
  String state;
  String city;
  DateTime createdAt;

  AddressModel({
    this.id,
    this.selected = false,
    required this.name,
    required this.zipCode,
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
    return 'AddressModel(id: $id,'
        ' name: $name,'
        ' selected: $selected,'
        ' zipCode: $zipCode,'
        ' street: $street,'
        ' number: $number,'
        ' complement: $complement,'
        ' neighborhood: $neighborhood,'
        ' state: $state,'
        ' city: $city,'
        ' createdAt: $createdAt)';
  }

  AddressModel copyWith({
    String? id,
    String? name,
    bool? selected,
    String? zipCode,
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
      selected: selected ?? this.selected,
      zipCode: zipCode ?? this.zipCode,
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
      'selected': selected,
      'zipCode': zipCode,
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
      selected: map['selected'] as bool,
      zipCode: map['zipCode'] as String,
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
}
