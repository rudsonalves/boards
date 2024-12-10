import 'dart:convert';

class ViaCEPAddressModel {
  final String cep;
  final String logradouro;
  final String complemento;
  final String unidade;
  final String bairro;
  final String localidade;
  final String uf;
  final String ibge;
  final String gia;
  final String ddd;
  final String siafi;

  ViaCEPAddressModel({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.unidade,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.ibge,
    required this.gia,
    required this.ddd,
    required this.siafi,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cep': cep,
      'logradouro': logradouro,
      'complemento': complemento,
      'unidade': unidade,
      'bairro': bairro,
      'localidade': localidade,
      'uf': uf,
      'ibge': ibge,
      'gia': gia,
      'ddd': ddd,
      'siafi': siafi,
    };
  }

  factory ViaCEPAddressModel.fromMap(Map<String, dynamic> map) {
    return ViaCEPAddressModel(
      cep: map['cep'] as String,
      logradouro: map['logradouro'] as String,
      complemento: map['complemento'] as String,
      unidade: map['unidade'] as String,
      bairro: map['bairro'] as String,
      localidade: map['localidade'] as String,
      uf: map['uf'] as String,
      ibge: map['ibge'] as String,
      gia: map['gia'] as String,
      ddd: map['ddd'] as String,
      siafi: map['siafi'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ViaCEPAddressModel.fromJson(String source) =>
      ViaCEPAddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddressCEP(cep: $cep,'
        ' logradouro: $logradouro,'
        ' complemento: $complemento,'
        ' unidade: $unidade,'
        ' bairro: $bairro,'
        ' localidade: $localidade,'
        ' uf: $uf,'
        ' ibge: $ibge,'
        ' gia: $gia,'
        ' ddd: $ddd,'
        ' siafi: $siafi)';
  }
}
