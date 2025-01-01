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

  void setNumber(String value) {
    address.number = value;

    _validateNumber();
  }

  void setComplement(String value) {
    address.complement = value;
  }

  void _validateName() {
    errorName.value = AddressValidator.name(address.name);
  }

  void _validateZipCode() {
    errorZipCode.value = AddressValidator.zipCode(address.zipCode);
  }

  void setZipCodeInvalid() {
    errorZipCode.value = 'CEP inválido!';
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
