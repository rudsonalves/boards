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

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '/core/abstracts/data_result.dart';
import '../../models/viacep_address.dart';

/// This class provides methods to interact with the ViaCEP API
/// to retrieve address information based on a given CEP (Brazilian postal code).
class ViacepRepository {
  /// Fetches address information from the ViaCEP API based on the provided CEP.
  ///
  /// [cep] - The Brazilian postal code to lookup.
  /// Returns a `ViaCEPAddressModel` containing the address information if successful,
  /// otherwise returns `null`.
  static Future<DataResult<ViaCEPAddressModel>> getLocalByCEP(
      String cep) async {
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
        return DataResult.success(address);
      } else {
        throw Exception('failed to load data (${response.statusCode}).');
      }
    } catch (err) {
      log('ViacepRepository.getLocalByCEP: $err');
      return DataResult.failure(GenericFailure(message: err.toString()));
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
