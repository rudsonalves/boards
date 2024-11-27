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
