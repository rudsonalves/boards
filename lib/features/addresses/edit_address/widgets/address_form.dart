import 'package:flutter/material.dart';

import '/core/utils/validators.dart';
import '/components/form_fields/custom_form_field.dart';
import '../edit_address_controller.dart';

class AddressForm extends StatefulWidget {
  final EditAddressController controller;
  final String? errorText;

  const AddressForm({
    super.key,
    required this.controller,
    required this.errorText,
  });

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  EditAddressController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CustomFormField(
            controller: controller.nameController,
            labelText: 'Endereço',
            hintText: 'Residencial, Comercial, ...',
            fullBorder: false,
            validator: AddressValidator.name,
            nextFocusNode: controller.zipFocus,
            textCapitalization: TextCapitalization.sentences,
          ),
          CustomFormField(
            labelText: 'CEP',
            controller: controller.zipCodeController,
            fullBorder: false,
            floatingLabelBehavior: null,
            validator: AddressValidator.zipCode,
            keyboardType: TextInputType.number,
            errorText: widget.errorText,
            focusNode: controller.zipFocus,
            nextFocusNode: controller.numberFocus,
            suffixIcon: IconButton(
              onPressed: controller.getAddressFromViacep,
              icon: const Icon(Icons.refresh),
            ),
          ),
          CustomFormField(
            labelText: 'Logadouro',
            controller: controller.streetController,
            fullBorder: false,
            readOnly: true,
            floatingLabelBehavior: null,
            validator: AddressValidator.street,
            suffixIcon: const Icon(Icons.auto_fix_high),
          ),
          CustomFormField(
            labelText: 'Número',
            controller: controller.numberController,
            fullBorder: false,
            floatingLabelBehavior: null,
            validator: AddressValidator.number,
            keyboardType: TextInputType.streetAddress,
            focusNode: controller.numberFocus,
            nextFocusNode: controller.complementFocus,
          ),
          CustomFormField(
            labelText: 'Complemento',
            controller: controller.complementController,
            fullBorder: false,
            floatingLabelBehavior: null,
            focusNode: controller.complementFocus,
            nextFocusNode: controller.buttonFocus,
            textCapitalization: TextCapitalization.sentences,
          ),
          CustomFormField(
            labelText: 'Bairro',
            controller: controller.neighborhoodController,
            fullBorder: false,
            readOnly: true,
            floatingLabelBehavior: null,
            validator: AddressValidator.neighborhood,
            suffixIcon: const Icon(Icons.auto_fix_high),
          ),
          CustomFormField(
            labelText: 'Estado',
            controller: controller.stateController,
            fullBorder: false,
            readOnly: true,
            floatingLabelBehavior: null,
            validator: AddressValidator.state,
            suffixIcon: const Icon(Icons.auto_fix_high),
          ),
          CustomFormField(
            labelText: 'Cidade',
            controller: controller.cityController,
            fullBorder: false,
            readOnly: true,
            floatingLabelBehavior: null,
            validator: AddressValidator.city,
            suffixIcon: const Icon(Icons.auto_fix_high),
          ),
        ],
      ),
    );
  }
}
