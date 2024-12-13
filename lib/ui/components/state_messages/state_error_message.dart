import 'package:flutter/material.dart';

class StateErrorMessage extends StatelessWidget {
  final String? message;
  final Widget? icon;
  final void Function() closeDialog;

  const StateErrorMessage({
    super.key,
    this.message,
    this.icon,
    required this.closeDialog,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface.withValues(alpha: 0.7),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Card(
                margin: EdgeInsets.all(12),
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      icon == null
                          ? Icon(
                              Icons.error,
                              color: colorScheme.error,
                              size: 60,
                            )
                          : icon!,
                      const SizedBox(height: 20),
                      Text(
                        message != null
                            ? message!
                            : 'Desculpe. Ocorreu algum problema.\n'
                                ' Tente mais tarde.',
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: FilledButton.icon(
                          onPressed: closeDialog,
                          label: const Text('Fechar'),
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
