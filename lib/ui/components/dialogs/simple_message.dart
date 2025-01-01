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
