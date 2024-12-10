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
