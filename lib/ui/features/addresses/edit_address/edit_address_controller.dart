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

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../logic/managers/addresses_manager.dart';
import '../../../../data/models/address.dart';
import '/core/singletons/current_user.dart';
import '../../../components/form_controllers/masked_text_controller.dart';
import '../../../../core/get_it.dart';
import '../../../../data/repository/gov_apis/viacep_repository.dart';
import 'edit_address_store.dart';

class EditAddressController {
  late final EditAddressStore store;

  final user = getIt<CurrentUser>();
  final addressManager = getIt<AddressesManager>();

  final nameController = TextEditingController();
  final zipCodeController = MaskedTextController(mask: '##.###-###');
  final streetController = TextEditingController();
  final numberController = TextEditingController();
  final complementController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  final zipFocus = FocusNode();
  final numberFocus = FocusNode();
  final complementFocus = FocusNode();
  final buttonFocus = FocusNode();

  List<AddressModel> get addresses => user.addresses;
  Iterable<String> get addressNames => addressManager.addressNames;

  bool zipCodeReativit = true;

  void init(EditAddressStore store) {
    this.store = store;

    zipCodeController.addListener(_checkZipCodeReady);
  }

  void dispose() {
    nameController.dispose();
    zipCodeController.dispose();
    streetController.dispose();
    numberController.dispose();
    complementController.dispose();
    neighborhoodController.dispose();
    cityController.dispose();
    stateController.dispose();
    numberFocus.dispose();
    complementFocus.dispose();
    buttonFocus.dispose();
    zipFocus.dispose();
  }

  void setFormFromAdresses(String addressName) {
    final address = user.addressByName(addressName);
    nameController.text = address!.name;
    zipCodeReativit = false;
    zipCodeController.text = address.zipCode;
    streetController.text = address.street;
    numberController.text = address.number;
    complementController.text = address.complement ?? '';
    neighborhoodController.text = address.neighborhood;
    cityController.text = address.city;
    stateController.text = address.state;
    zipCodeReativit = true;
  }

  Future<void> getAddressFromViacep() async {
    try {
      store.setStateLoading();
      final result =
          await ViacepRepository.getLocalByCEP(zipCodeController.text);
      if (result.isFailure || result.data == null) {
        store.setZipCodeInvalid();
        throw Exception(result.error ?? 'unknow error');
      }
      final response = result.data!;
      streetController.text = response.logradouro;
      neighborhoodController.text = response.bairro;
      cityController.text = response.localidade;
      stateController.text = response.uf;
      store.setStateSuccess();
    } catch (err) {
      final message = err.toString();
      log(message);
      // store.setError(message);
      store.setStateSuccess();
    }
  }

  Future<void> saveAddressFrom() async {
    try {
      store.setStateLoading();
      final newAddress = AddressModel(
        name: nameController.text,
        zipCode: zipCodeController.text,
        street: streetController.text,
        number: numberController.text,
        complement: complementController.text,
        neighborhood: neighborhoodController.text,
        state: stateController.text,
        city: cityController.text,
      );
      await user.saveAddress(newAddress);
      store.setStateSuccess();
    } catch (err) {
      final message = err.toString();
      log(message);
      store.setError(message);
    }
  }

  void _checkZipCodeReady() {
    if (!zipCodeReativit) return;
    final cleanZip = zipCodeController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanZip.length == 8) {
      getAddressFromViacep();
    } else {
      streetController.text = '';
      neighborhoodController.text = '';
      cityController.text = '';
      stateController.text = '';
    }
  }
}
