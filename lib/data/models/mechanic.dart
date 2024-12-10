// ignore_for_file: public_member_api_docs, sort_constructors_first

class MechanicModel {
  final String? id;
  final String name;
  final String? description;

  MechanicModel({
    this.id,
    required this.name,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory MechanicModel.fromMap(Map<String, dynamic> map) {
    return MechanicModel(
      id: map['id'] as String?,
      name: map['name'] as String,
      description: map['description'] as String?,
    );
  }

  @override
  String toString() {
    return 'MechanicModel( id: $id,'
        ' name: $name,'
        ' description: $description)';
  }

  MechanicModel copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return MechanicModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(covariant MechanicModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}
