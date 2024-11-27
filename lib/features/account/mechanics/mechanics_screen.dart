import 'package:flutter/material.dart';

import '/core/models/mechanic.dart';
import '/components/widgets/state_error_message.dart';
import '/components/widgets/state_loading_message.dart';
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
