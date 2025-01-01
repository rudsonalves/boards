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

class PasswordFormField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? passwordController;
  final String? Function(String?)? validator;
  final String? errorText;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool fullBorder;

  PasswordFormField({
    super.key,
    required this.labelText,
    this.hintText,
    this.passwordController,
    this.errorText,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.textInputAction,
    this.focusNode,
    this.nextFocusNode,
    this.fullBorder = true,
  });

  final notVisible = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ValueListenableBuilder(
        valueListenable: notVisible,
        builder: (context, value, _) {
          return TextFormField(
            controller: passwordController,
            validator: validator,
            focusNode: focusNode,
            obscureText: value,
            textInputAction: textInputAction ?? TextInputAction.done,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              errorText: errorText,
              border: fullBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: IconButton(
                onPressed: () {
                  notVisible.value = !notVisible.value;
                },
                icon: Icon(
                  notVisible.value ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            onChanged: onChanged,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(nextFocusNode);
              if (onFieldSubmitted != null) {
                onFieldSubmitted!(value);
              }
            },
          );
        },
      ),
    );
  }
}
