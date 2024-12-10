import 'package:flutter_test/flutter_test.dart';
import 'package:boards/data/repository/gov_apis/ibge_repository.dart';

void main() {
  group('ibge repository ...', () {
    test('getUFListFromApi', () async {
      final states = await IbgeRepository.getStateList();
      final stateES =
          states.where((item) => item.nome == 'Espírito Santo').toList()[0];

      expect(stateES.nome, 'Espírito Santo');
    });

    test('getCityListFromApi', () async {
      final states = await IbgeRepository.getStateList();
      final stateES =
          states.where((item) => item.nome == 'Espírito Santo').toList()[0];
      final cities = await IbgeRepository.getCityListFromApi(stateES);

      var city = cities.where((item) => item.id == 3200102).toList()[0];
      expect(city.nome, 'Afonso Cláudio');

      city = cities.where((item) => item.id == 3201308).toList()[0];
      expect(city.nome, 'Cariacica');
    });
  });
}
