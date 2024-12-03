class AddressModel {
  final String? id;
  final bool selected;
  final String name;
  final String zipCode;
  final String street;
  final String number;
  final String? complement;
  final String neighborhood;
  final String state;
  final String city;
  final DateTime createdAt;

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
