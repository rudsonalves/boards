import 'package:flutter/material.dart';

enum SQMessageType { yesNo, confirmCancel }

class SimpleQuestionDialog extends StatelessWidget {
  final String title;
  final String message;
  final SQMessageType type;

  const SimpleQuestionDialog({
    super.key,
    required this.title,
    required this.message,
    this.type = SQMessageType.yesNo,
  });

  static Future<bool> open(
    BuildContext context, {
    required String title,
    required String message,
    SQMessageType? type,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => SimpleQuestionDialog(
            title: title,
            message: message,
            type: type ?? SQMessageType.yesNo,
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(title),
      backgroundColor: colorScheme.onSecondary,
      content: Text(message),
      actions: [
        FilledButton.tonal(
          onPressed: () => Navigator.pop(context, true),
          child: Text(type == SQMessageType.yesNo ? 'Sim' : 'Confirmar'),
        ),
        FilledButton.tonal(
          onPressed: () => Navigator.pop(context, false),
          child: Text(type == SQMessageType.yesNo ? 'Não' : 'Cancelar'),
        ),
      ],
    );
  }
}
