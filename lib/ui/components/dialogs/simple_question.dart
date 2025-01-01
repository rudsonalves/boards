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
