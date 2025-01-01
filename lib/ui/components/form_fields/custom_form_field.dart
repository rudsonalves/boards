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

class CustomFormField extends StatelessWidget {
  final String? labelText;
  final String? initialValue;
  final TextStyle? labelStyle;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool fullBorder;
  final int? maxLines;
  final int? minLines;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final bool readOnly;
  final Widget? suffixIcon;
  final String? errorText;
  final String? suffixText;
  final String? prefixText;

  CustomFormField({
    super.key,
    this.labelText,
    this.initialValue,
    this.labelStyle,
    this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.nextFocusNode,
    this.fullBorder = true,
    this.maxLines = 1,
    this.minLines,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.readOnly = false,
    this.suffixIcon,
    this.errorText,
    this.textCapitalization,
    this.suffixText,
    this.prefixText,
  });

  final errorString = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        validator: validator,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction ?? TextInputAction.next,
        minLines: minLines,
        maxLines: maxLines,
        readOnly: readOnly,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: labelStyle,
          hintText: hintText,
          errorText: errorText,
          suffixIcon: suffixIcon,
          suffixText: suffixText,
          prefixText: prefixText,
          border: fullBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          floatingLabelBehavior: floatingLabelBehavior,
        ),
        onChanged: onChanged,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(nextFocusNode);
          if (onFieldSubmitted != null) {
            onFieldSubmitted!(value);
          }
        },
      ),
    );
  }
}
