import 'package:flutter/material.dart';

import '/core/models/mechanic.dart';
import '/components/form_fields/custom_form_field.dart';

class MechanicDialog extends StatefulWidget {
  final MechanicModel? mech;

  const MechanicDialog({
    super.key,
    this.mech,
  });

  static Future<MechanicModel?> open(
    BuildContext context, [
    MechanicModel? mech,
  ]) async {
    final result = await showDialog<MechanicModel?>(
      context: context,
      builder: (context) => MechanicDialog(mech: mech),
    );
    return result;
  }

  @override
  State<MechanicDialog> createState() => _MechanicDialogState();
}

class _MechanicDialogState extends State<MechanicDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  late final bool isEdit;

  @override
  void initState() {
    super.initState();

    if (widget.mech != null) {
      nameController.text = widget.mech!.name;
      descriptionController.text = widget.mech!.description ?? '';
      isEdit = true;
    } else {
      isEdit = false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  _addButton() {
    final mech = MechanicModel(
      id: widget.mech?.id,
      name: nameController.text,
      description: descriptionController.text,
    );

    Navigator.pop(context, mech);
  }

  _cancelButton() {
    Navigator.pop(context, null);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SimpleDialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: colorScheme.surfaceContainerHigh,
      contentPadding: const EdgeInsets.all(12),
      title: Text(isEdit ? 'Editar Mecânica' : 'Nova Mecânica'),
      children: [
        CustomFormField(
          controller: nameController,
          labelText: 'Mecânica',
          hintText: 'Nome da mecânica',
          fullBorder: false,
        ),
        CustomFormField(
          controller: descriptionController,
          labelText: 'Descrição',
          hintText: 'Adicione uma descrição',
          fullBorder: false,
          minLines: 1,
          maxLines: 5,
        ),
        OverflowBar(
          alignment: MainAxisAlignment.spaceAround,
          children: [
            FilledButton.tonalIcon(
              onPressed: _addButton,
              label: Text(isEdit ? 'Atualizar' : 'Adicionar'),
              icon: Icon(isEdit ? Icons.update : Icons.add),
            ),
            FilledButton.tonalIcon(
              onPressed: _cancelButton,
              label: const Text('Cancelar'),
              icon: const Icon(Icons.cancel),
            ),
          ],
        ),
      ],
    );
  }
}
