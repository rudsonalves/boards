// ignore_for_file: public_member_api_docs, sort_constructors_first

class BGNameModel {
  String? id;
  String? name;

  BGNameModel({
    this.id,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory BGNameModel.fromMap(Map<String, dynamic> map) {
    return BGNameModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  @override
  String toString() => 'BGNameModel(id: $id, name: $name)';

  BGNameModel copyWith({
    String? id,
    String? name,
  }) {
    return BGNameModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
