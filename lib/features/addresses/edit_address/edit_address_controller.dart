import 'dart:developer';

import 'package:flutter/material.dart';

import '/core/models/address.dart';
import '/core/singletons/current_user.dart';
import '/components/custon_controllers/masked_text_controller.dart';
import '/get_it.dart';
import '/repository/gov_apis/viacep_repository.dart';
import 'edit_address_state.dart';

class EditAddressController extends ChangeNotifier {
  EditAddressState _state = EditAddressStateInitial();

  EditAddressState get state => _state;

  void _changeState(EditAddressState newState) {
    _state = newState;
    notifyListeners();
  }

  final user = getIt<CurrentUser>();

  final formKey = GlobalKey<FormState>();
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
  Iterable<String> get addressNames => user.addressNames;

  bool zipCodeReativit = true;

  bool get valid {
    return formKey.currentState != null && formKey.currentState!.validate();
  }

  void init() {
    zipCodeController.addListener(_checkZipCodeReady);
  }

  @override
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
    super.dispose();
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
      _changeState(EditAddressStateLoading());
      final response =
          await ViacepRepository.getLocalByCEP(zipCodeController.text);
      streetController.text = response.logradouro;
      neighborhoodController.text = response.bairro;
      cityController.text = response.localidade;
      stateController.text = response.uf;
      _changeState(EditAddressStateSuccess());
    } catch (err) {
      log(err.toString());
      _changeState(EditAddressStateError());
    }
  }

  Future<void> saveAddressFrom() async {
    try {
      _changeState(EditAddressStateLoading());
      final newAddress = AddressModel(
        name: nameController.text,
        zipCode: zipCodeController.text,
        ownerId: user.userId,
        street: streetController.text,
        number: numberController.text,
        complement: complementController.text,
        neighborhood: neighborhoodController.text,
        state: stateController.text,
        city: cityController.text,
      );
      await user.saveAddress(newAddress);
      _changeState(EditAddressStateSuccess());
    } catch (err) {
      log(err.toString());
      _changeState(EditAddressStateError());
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
