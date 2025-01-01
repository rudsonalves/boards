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

import '../../../../data/models/mechanic.dart';
import '../../../components/state_messages/state_error_message.dart';
import '../../../components/state_messages/state_loading_message.dart';
import 'mechanics_store.dart';
import 'mechanics_controller.dart';
import 'widgets/mach_floating_action_button.dart';
import 'widgets/mech_app_bar.dart';
import 'widgets/mechanic_dialog.dart';
import 'widgets/show_mechs/show_only_selected_mechs.dart';
import 'widgets/show_mechs/show_all_mechs.dart';

class MechanicsScreen extends StatefulWidget {
  final List<String>? selectedMechIds;

  const MechanicsScreen({
    super.key,
    required this.selectedMechIds,
  });

  static const routeName = '/mechanics';

  @override
  State<MechanicsScreen> createState() => _MechanicsScreenState();
}

class _MechanicsScreenState extends State<MechanicsScreen> {
  final ctrl = MechanicsController();
  final store = MechanicsStore();

  @override
  void initState() {
    super.initState();
    store.init(widget.selectedMechIds);
    ctrl.init(store);
  }

  @override
  void dispose() {
    store.dispose();

    super.dispose();
  }

  void _closeMechanicsPage() {
    Navigator.pop(context, store.selectedMechIds);
  }

  Future<void> _addMechanic() async {
    final mech = await MechanicDialog.open(context);
    if (mech != null) ctrl.add(mech);
  }

  Future<void> _editMechanic(MechanicModel mech) async {
    final editedMech = await MechanicDialog.open(context, mech.copyWith());

    if (editedMech != null && mech != editedMech) {
      await ctrl.update(editedMech);
    }
  }

  Future<bool> _deleteMechanic(MechanicModel mech) async {
    final result = await showDialog<bool?>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Remover Mecânica'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Remover a mecânica "${mech.name}"?'),
              ],
            ),
            actions: [
              FilledButton.tonalIcon(
                onPressed: () => Navigator.pop(context, true),
                label: Text('Remover'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => Navigator.pop(context, false),
                label: Text('Cancelar'),
              ),
            ],
          ),
        ) ??
        false;
    if (result) {
      final result = await ctrl.removeMechs(mech);
      return result;
    }
    return false;
  }

  Widget showMechList() {
    if (!store.showSelected.value) {
      return ShowAllMechs(
        store: store,
        deleteMech: _deleteMechanic,
        editMechanic: _editMechanic,
      );
    } else {
      return ShowOnlySelectedMechs(
        store: store,
      );
    }
  }

  Future<void> _importCSV() async {
    // Select a CSV file
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result == null || result.files.single.path == null) return;

    ctrl.importCSV(result.files.single.path!);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store.state,
      builder: (context, _) {
        return Stack(
          children: [
            Scaffold(
              appBar: MechAppBar(
                ctrl: ctrl,
                store: store,
                onPressed: _closeMechanicsPage,
              ),
              floatingActionButton: MechFloatingActionButton(
                onPressBack: _closeMechanicsPage,
                onPressAdd: _addMechanic,
                onPressDeselect: ctrl.deselectAll,
                onPressImportCSV: _importCSV,
              ),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ValueListenableBuilder(
                    valueListenable: store.updateMechList,
                    builder: (context, _, __) {
                      return showMechList();
                    }),
              ),
            ),
            if (store.isLoading)
              const Positioned.fill(
                child: StateLoadingMessage(),
              ),
            if (store.isError)
              Positioned.fill(
                child: StateErrorMessage(
                  closeDialog: ctrl.closeDialog,
                ),
              ),
          ],
        );
      },
    );
  }
}
