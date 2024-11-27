import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/models/viacep_address.dart';

/// This class provides methods to interact with the ViaCEP API
/// to retrieve address information based on a given CEP (Brazilian postal code).
class ViacepRepository {
  /// Fetches address information from the ViaCEP API based on the provided CEP.
  ///
  /// [cep] - The Brazilian postal code to lookup.
  /// Returns a `ViaCEPAddressModel` containing the address information if successful,
  /// otherwise returns `null`.
  static Future<ViaCEPAddressModel> getLocalByCEP(String cep) async {
    try {
      String cleanCEP = _cleanCEP(cep);
      final urlCEP = 'https://viacep.com.br/ws/$cleanCEP/json/';

      final response = await http.get(Uri.parse(urlCEP));
      if (response.statusCode == HttpStatus.ok) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data['erro'] == true) {
          throw Exception('invalid CEP.');
        }

        final address = ViaCEPAddressModel.fromMap(data);
        return address;
      } else {
        throw Exception('failed to load data (${response.statusCode}).');
      }
    } catch (err) {
      log('ViacepRepository.getLocalByCEP: $err');
      throw Exception(err);
    }
  }

  /// Cleans the provided CEP by removing any non-digit characters.
  ///
  /// [cep] - The CEP to clean.
  /// Returns a string containing only the digits of the CEP.
  static String _cleanCEP(String cep) {
    return cep.replaceAll(RegExp(r'[^\d]'), '');
  }
}
