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

import 'dart:io';

import '../../features/shop/product/widgets/title_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomMessage extends StatelessWidget {
  final String title;
  final String message;

  const BottomMessage({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        if (!Platform.isAndroid) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleProduct(
                  color: colorScheme.primary,
                  title: title,
                ),
                Text(message),
                FilledButton.tonalIcon(
                  onPressed: Navigator.of(context).pop,
                  label: const Text('Fechar'),
                ),
              ],
            ),
          );
        } else {
          return CupertinoActionSheet(
            title: Text(title),
            message: Text(message),
            actions: [
              CupertinoActionSheetAction(
                onPressed: Navigator.of(context).pop,
                child: const Text('Fechar'),
              ),
            ],
          );
        }
      },
    );
  }
}
