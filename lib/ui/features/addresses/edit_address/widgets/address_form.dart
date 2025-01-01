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

import 'package:flutter/material.dart';

import '../edit_address_store.dart';
import '/core/utils/validators.dart';
import '../../../../components/form_fields/custom_form_field.dart';
import '../edit_address_controller.dart';

class AddressForm extends StatefulWidget {
  final EditAddressController ctrl;
  final String? errorText;

  const AddressForm({
    super.key,
    required this.ctrl,
    required this.errorText,
  });

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  EditAddressController get ctrl => widget.ctrl;
  EditAddressStore get store => ctrl.store;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
            valueListenable: store.errorName,
            builder: (context, errorName, _) {
              return CustomFormField(
                controller: ctrl.nameController,
                labelText: 'Endereço',
                hintText: 'Residencial, Comercial, ...',
                fullBorder: false,
                errorText: errorName,
                nextFocusNode: ctrl.zipFocus,
                textCapitalization: TextCapitalization.sentences,
                onChanged: store.setName,
              );
            }),
        ValueListenableBuilder(
            valueListenable: store.errorZipCode,
            builder: (context, errorZipCode, _) {
              return CustomFormField(
                labelText: 'CEP',
                controller: ctrl.zipCodeController,
                fullBorder: false,
                floatingLabelBehavior: null,
                keyboardType: TextInputType.number,
                errorText: errorZipCode,
                focusNode: ctrl.zipFocus,
                onChanged: store.setZipCode,
                nextFocusNode: ctrl.numberFocus,
                suffixIcon: IconButton(
                  onPressed: ctrl.getAddressFromViacep,
                  icon: const Icon(Icons.refresh),
                ),
              );
            }),
        CustomFormField(
          labelText: 'Logadouro',
          controller: ctrl.streetController,
          fullBorder: false,
          readOnly: true,
          floatingLabelBehavior: null,
          validator: AddressValidator.street,
          suffixIcon: const Icon(Icons.auto_fix_high),
        ),
        ValueListenableBuilder(
            valueListenable: store.errorNumber,
            builder: (context, errorNumber, _) {
              return CustomFormField(
                labelText: 'Número',
                controller: ctrl.numberController,
                fullBorder: false,
                floatingLabelBehavior: null,
                onChanged: store.setNumber,
                errorText: errorNumber,
                keyboardType: TextInputType.streetAddress,
                focusNode: ctrl.numberFocus,
                nextFocusNode: ctrl.complementFocus,
              );
            }),
        CustomFormField(
          labelText: 'Complemento',
          controller: ctrl.complementController,
          fullBorder: false,
          floatingLabelBehavior: null,
          focusNode: ctrl.complementFocus,
          onChanged: store.setComplement,
          nextFocusNode: ctrl.buttonFocus,
          textCapitalization: TextCapitalization.sentences,
        ),
        CustomFormField(
          labelText: 'Bairro',
          controller: ctrl.neighborhoodController,
          fullBorder: false,
          readOnly: true,
          floatingLabelBehavior: null,
          // validator: AddressValidator.neighborhood,
          suffixIcon: const Icon(Icons.auto_fix_high),
        ),
        CustomFormField(
          labelText: 'Estado',
          controller: ctrl.stateController,
          fullBorder: false,
          readOnly: true,
          floatingLabelBehavior: null,
          // validator: AddressValidator.state,
          suffixIcon: const Icon(Icons.auto_fix_high),
        ),
        CustomFormField(
          labelText: 'Cidade',
          controller: ctrl.cityController,
          fullBorder: false,
          readOnly: true,
          floatingLabelBehavior: null,
          // validator: AddressValidator.city,
          suffixIcon: const Icon(Icons.auto_fix_high),
        ),
      ],
    );
  }
}
