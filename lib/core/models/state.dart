import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class RegionModel {
  final int id;
  final String sigla;
  final String nome;

  RegionModel({
    required this.id,
    required this.sigla,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sigla': sigla,
      'nome': nome,
    };
  }

  factory RegionModel.fromMap(Map<String, dynamic> map) {
    return RegionModel(
      id: map['id'] as int,
      sigla: map['sigla'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegionModel.fromJson(String source) =>
      RegionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Regiao(id: $id, sigla: $sigla, nome: $nome)';
}

class StateBrModel {
  final int id;
  final String sigla;
  final String nome;
  // final RegionModel regiao;

  StateBrModel({
    required this.id,
    required this.sigla,
    required this.nome,
    // required this.regiao,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sigla': sigla,
      'nome': nome,
      // 'regiao': regiao.toMap(),
    };
  }

  factory StateBrModel.fromMap(Map<String, dynamic> map) {
    return StateBrModel(
      id: map['id'] as int,
      sigla: map['sigla'] as String,
      nome: map['nome'] as String,
      // regiao: RegionModel.fromMap(map['regiao'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory StateBrModel.fromJson(String source) =>
      StateBrModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'State(id: $id, sigla: $sigla, nome: $nome)';
  }
}
