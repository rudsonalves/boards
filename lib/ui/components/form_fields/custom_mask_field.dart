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

import '../form_controllers/masked_text_controller.dart';

class CustomMaskField extends StatefulWidget {
  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintText;
  final String mask;
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

  const CustomMaskField({
    super.key,
    this.labelText,
    this.labelStyle,
    required this.mask,
    this.hintText,
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

  @override
  State<CustomMaskField> createState() => _CustomMaskFieldState();
}

class _CustomMaskFieldState extends State<CustomMaskField> {
  final errorString = ValueNotifier<String?>(null);
  late final MaskedTextController controller;

  @override
  void initState() {
    super.initState();
    controller = MaskedTextController(mask: widget.mask);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        controller: controller,
        validator: widget.validator,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        readOnly: widget.readOnly,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: widget.labelStyle,
          hintText: widget.hintText,
          errorText: widget.errorText,
          suffixIcon: widget.suffixIcon,
          suffixText: widget.suffixText,
          prefixText: widget.prefixText,
          border: widget.fullBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          floatingLabelBehavior: widget.floatingLabelBehavior,
        ),
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
      ),
    );
  }
}
