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

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class GetImage extends StatefulWidget {
  const GetImage({super.key});

  static Future<String?> openDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => GetImage(),
    );

    return result;
  }

  @override
  State<GetImage> createState() => _GetImageState();
}

class _GetImageState extends State<GetImage> {
  final imageController = TextEditingController();

  String? filePath;

  @override
  void dispose() {
    imageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Imagem'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Entre com o path da imagem:'),
          TextField(
            controller: imageController,
          ),
        ],
      ),
      actions: [
        IconButton.filledTonal(
          onPressed: () async {
            final FilePickerResult? result =
                await FilePicker.platform.pickFiles();
            filePath =
                result != null ? filePath = result.files.single.path : null;
            if (filePath != null) imageController.text = filePath!;
          },
          icon: Icon(Icons.folder_open_rounded),
          tooltip: 'Arquivo local',
        ),
        IconButton.filledTonal(
          onPressed: () => Navigator.pop(context, filePath),
          icon: const Icon(Icons.check),
          tooltip: 'Aplicar',
        ),
        IconButton.filledTonal(
          onPressed: () => Navigator.pop(context, null),
          icon: const Icon(Icons.cancel),
          tooltip: 'Cancelar',
        ),
      ],
    );
  }
}
