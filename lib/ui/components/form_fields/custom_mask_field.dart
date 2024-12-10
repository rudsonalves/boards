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
