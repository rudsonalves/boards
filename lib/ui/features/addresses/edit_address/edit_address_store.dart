import 'package:boards/data/models/address.dart';
import 'package:boards/core/utils/validators.dart';
import 'package:flutter/foundation.dart';

import '../../../components/state/state_store.dart';

class EditAddressStore extends StateStore {
  final AddressModel address;

  final errorName = ValueNotifier<String?>('');

  final errorZipCode = ValueNotifier<String?>('');

  final errorNumber = ValueNotifier<String?>('');

  @override
  void dispose() {
    errorName.dispose();
    errorZipCode.dispose();
    errorNumber.dispose();

    super.dispose();
  }

  EditAddressStore({
    AddressModel? address,
  }) : address = address ??
            AddressModel(
              name: 'name',
              zipCode: '',
              street: '',
              number: '',
              neighborhood: '',
              state: '',
              city: '',
            );

  void setName(String value) {
    if (value.isNotEmpty) {
      address.name = value;
      _validateName();
    }
  }

  void setZipCode(String value) {
    address.zipCode = value;
    _validateZipCode();
  }

  void setStreet(String value) {
    address.street = value;
  }

  void setNumber(String value) {
    address.number = value;

    _validateNumber();
  }

  void setComplement(String value) {
    address.complement = value;
  }

  void setNeighborhood(String value) {
    address.neighborhood = value;
  }

  void setAddressState(String value) {
    address.state = value;
  }

  void setCity(String value) {
    address.city = value;
  }

  void _validateName() {
    errorName.value = AddressValidator.name(address.name);
  }

  void _validateZipCode() {
    errorZipCode.value = AddressValidator.zipCode(address.zipCode);
  }

  void _validateNumber() {
    errorNumber.value = address.number.isEmpty ? 'Numero é obrigatório.' : null;
  }

  bool isValid() {
    return errorName.value == null &&
        errorNumber.value == null &&
        errorZipCode.value == null &&
        errorMessage == null;
  }
}
