import 'package:flutter/material.dart';

class StateMessage extends StatelessWidget {
  final String? title;
  final String message;
  final Color? backgoundColor;
  final IconData? iconData;
  final void Function() buttonFunc1;
  final IconData? buttonIcon1;
  final String? buttonText1;
  final void Function()? buttonFunc2;
  final IconData? buttonIcon2;
  final String? buttonText2;

  const StateMessage({
    super.key,
    this.title,
    required this.message,
    this.backgoundColor,
    this.iconData,
    required this.buttonFunc1,
    this.buttonIcon1,
    this.buttonText1,
    this.buttonFunc2,
    this.buttonIcon2,
    this.buttonText2,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        backgoundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Card(
            margin: EdgeInsets.all(12),
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  if (iconData != null) Icon(iconData!),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: OverflowBar(
                      children: [
                        FilledButton.icon(
                          onPressed: buttonFunc1,
                          label: Text(buttonText1 ?? 'Fechar'),
                          icon: Icon(buttonIcon1 ?? Icons.close),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
