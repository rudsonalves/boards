import 'package:flutter/material.dart';

class DropdownFormField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextCapitalization? textCapitalization;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool fullBorder;
  final int? maxLines;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final bool readOnly;
  final Widget? suffixIcon;
  final String? errorText;
  final List<String> stringList;
  final void Function(String)? onSelected;

  DropdownFormField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.nextFocusNode,
    this.fullBorder = true,
    this.maxLines = 1,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.readOnly = false,
    this.suffixIcon,
    this.errorText,
    List<String>? stringList,
    this.textCapitalization,
    this.onSelected,
  }) : stringList = stringList ?? [];

  final errorString = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        controller: controller,
        validator: validator,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction ?? TextInputAction.next,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        maxLines: maxLines,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          errorText: errorText,
          suffixIcon: PopupMenuButton<String>(
            icon: const Icon(Icons.download),
            itemBuilder: (context) => stringList
                .map(
                  (item) => PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ),
                )
                .toList(),
            onSelected: onSelected,
          ),
          border: fullBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          floatingLabelBehavior: floatingLabelBehavior,
        ),
        onChanged: (value) {
          if (value.length > 2 && validator != null) {
            errorString.value = validator!(value);
          }
        },
        onFieldSubmitted: (value) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }
}
