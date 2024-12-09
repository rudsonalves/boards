import 'dart:developer';

import 'package:flutter/material.dart';

import '/data_managers/addresses_manager.dart';
import '/core/models/address.dart';
import '/core/singletons/current_user.dart';
import '/components/custon_controllers/masked_text_controller.dart';
import '/get_it.dart';
import '/repository/gov_apis/viacep_repository.dart';
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
      final response =
          await ViacepRepository.getLocalByCEP(zipCodeController.text);
      streetController.text = response.logradouro;
      neighborhoodController.text = response.bairro;
      cityController.text = response.localidade;
      stateController.text = response.uf;
      store.setStateSuccess();
    } catch (err) {
      final message = err.toString();
      log(message);
      store.setError(message);
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
