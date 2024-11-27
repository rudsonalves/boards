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
