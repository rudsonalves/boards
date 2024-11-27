import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomFilledButton({
    super.key,
    this.onPressed,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          backgroundColor?.withOpacity(0.45),
        ),
        foregroundColor: WidgetStatePropertyAll(foregroundColor),
      ),
    );
  }
}
