import 'package:flutter/material.dart';

enum MessageType { none, error, warning }

class SimpleMessage extends StatelessWidget {
  final String title;
  final String message;
  final MessageType type;

  const SimpleMessage({
    super.key,
    required this.title,
    required this.message,
    this.type = MessageType.none,
  });

  static Future<void> open(
    BuildContext context, {
    required String title,
    required String message,
    MessageType? type,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) => SimpleMessage(
        title: title,
        message: message,
        type: type ?? MessageType.none,
      ),
    );
  }

  Icon? get typeIcon {
    switch (type) {
      case MessageType.none:
        return null;
      case MessageType.error:
        return const Icon(Icons.error, size: 60, color: Colors.red);
      case MessageType.warning:
        return const Icon(Icons.warning, size: 60, color: Colors.yellow);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(title),
      backgroundColor: colorScheme.onSecondary,
      icon: typeIcon,
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
