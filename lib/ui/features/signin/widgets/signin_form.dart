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

import '../../../components/form_fields/custom_form_field.dart';
import '../../../components/form_fields/password_form_field.dart';
import '../signin_store.dart';

class SignInForm extends StatefulWidget {
  final SignInStore store;
  final void Function() userLogin;
  final void Function() navLostPassword;

  const SignInForm({
    super.key,
    required this.store,
    required this.userLogin,
    required this.navLostPassword,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final passwordFocus = FocusNode();

  @override
  void dispose() {
    passwordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ValueListenableBuilder(
            valueListenable: widget.store.errorEmail,
            builder: (context, errorEmail, _) {
              return CustomFormField(
                labelText: 'E-mail',
                hintText: 'seu-email@provedor.com',
                keyboardType: TextInputType.emailAddress,
                errorText: errorEmail,
                onChanged: widget.store.setEmail,
                nextFocusNode: passwordFocus,
              );
            }),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: widget.navLostPassword,
            child: Text(
              'Esqueceu a senha?',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 12,
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: widget.store.errorPassword,
          builder: (context, errorPassword, _) {
            return PasswordFormField(
              labelText: 'Senha',
              errorText: errorPassword,
              onChanged: widget.store.setPassword,
              focusNode: passwordFocus,
              onFieldSubmitted: (value) => widget.userLogin(),
            );
          },
        ),
      ],
    );
  }
}
