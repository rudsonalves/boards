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

import '/core/utils/validators.dart';
import '../../../components/form_fields/custom_form_field.dart';
import '../../../components/form_fields/custom_mask_field.dart';
import '../../../components/form_fields/password_form_field.dart';
import '../signup_store.dart';

class SignUpForm extends StatefulWidget {
  final SignupStore store;
  final void Function() signupUser;

  const SignUpForm({
    super.key,
    required this.store,
    required this.signupUser,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final checkPassword = FocusNode();

  @override
  void dispose() {
    checkPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ValueListenableBuilder(
            valueListenable: widget.store.errorName,
            builder: (context, errorName, _) {
              return CustomFormField(
                labelText: 'Nome',
                hintText: 'Como aparecerá em seus anúncios',
                errorText: errorName,
                onChanged: widget.store.setName,
                validator: Validator.name,
                textCapitalization: TextCapitalization.words,
                // nextFocusNode: controller.emailFocusNode,
              );
            }),
        ValueListenableBuilder(
            valueListenable: widget.store.errorEmail,
            builder: (context, errorEmail, _) {
              return CustomFormField(
                labelText: 'E-mail',
                hintText: 'seu-email@provedor.com',
                errorText: errorEmail,
                onChanged: widget.store.setEmail,
                validator: Validator.email,
                keyboardType: TextInputType.emailAddress,
                // focusNode: controller.emailFocusNode,
                // nextFocusNode: controller.phoneFocusNode,
              );
            }),
        ValueListenableBuilder(
            valueListenable: widget.store.errorPhone,
            builder: (context, errorPhone, _) {
              return CustomMaskField(
                labelText: 'Celular',
                hintText: '(19) 9999-9999',
                mask: '(##) #####-####',
                errorText: errorPhone,
                onChanged: widget.store.setPhone,

                keyboardType: TextInputType.phone,
                // focusNode: controller.phoneFocusNode,
                // nextFocusNode: controller.passwordFocusNode,
              );
            }),
        ValueListenableBuilder(
            valueListenable: widget.store.errorPassword,
            builder: (context, errorPassword, _) {
              return PasswordFormField(
                labelText: 'Senha',
                hintText: '6+ letras e números',
                errorText: errorPassword,
                onChanged: widget.store.setPassword,
                textInputAction: TextInputAction.next,
                nextFocusNode: checkPassword,
              );
            }),
        ValueListenableBuilder(
            valueListenable: widget.store.errorCheckPassword,
            builder: (context, errorCheckPassword, _) {
              return PasswordFormField(
                labelText: 'Confirmar senha',
                hintText: '6+ letras e números',
                errorText: errorCheckPassword,
                onChanged: widget.store.setCheckPassword,
                focusNode: checkPassword,
                onFieldSubmitted: (value) => widget.signupUser(),
              );
            }),
      ],
    );
  }
}
