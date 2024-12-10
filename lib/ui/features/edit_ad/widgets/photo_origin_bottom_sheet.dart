import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoOriginBottomSheet extends StatelessWidget {
  final void Function() getFromCamera;
  final void Function() getFromGallery;

  const PhotoOriginBottomSheet({
    super.key,
    required this.getFromCamera,
    required this.getFromGallery,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        if (Platform.isAndroid) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Selecionar origem das imagens',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const Divider(),
                TextButton.icon(
                  onPressed: getFromCamera,
                  label: const Text('Câmera'),
                  icon: const Icon(Icons.camera_alt),
                ),
                TextButton.icon(
                  onPressed: getFromGallery,
                  label: const Text('Galeria'),
                  icon: const Icon(Icons.photo_library_outlined),
                ),
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          );
        } else {
          return CupertinoActionSheet(
            title: const Text('Selecionar origem das imagens'),
            actions: [
              CupertinoActionSheetAction(
                onPressed: getFromCamera,
                child: const Text('Câmera'),
              ),
              CupertinoActionSheetAction(
                onPressed: getFromGallery,
                child: const Text('Galeria'),
              ),
              CupertinoActionSheetAction(
                onPressed: Navigator.of(context).pop,
                child: const Text('Cancelar'),
              ),
            ],
          );
        }
      },
    );
  }
}
