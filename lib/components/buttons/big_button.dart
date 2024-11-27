import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final Color color;
  final String label;
  final VoidCallback onPressed;
  final FocusNode? focusNode;
  final IconData? iconData;

  const BigButton({
    super.key,
    required this.color,
    required this.label,
    required this.onPressed,
    this.focusNode,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.tonal(
              focusNode: focusNode,
              onPressed: onPressed,
              style: ButtonStyle(
                shape: ButtonStyleButton.allOrNull(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all(
                  color.withOpacity(.3),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (iconData != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          iconData,
                          size: 22,
                        ),
                      ),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
