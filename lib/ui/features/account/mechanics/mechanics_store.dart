import 'package:flutter/material.dart';

import '../../../../data/models/mechanic.dart';
import '../../../components/state/state_store.dart';
import '../../../../logic/managers/mechanics_manager.dart';
import '../../../../core/get_it.dart';

/// A state management store for managing mechanics selection and UI flags.
///
/// Fields:
/// - [selectedsMechs]: List of selected mechanics.
/// - [counter]: Tracks the number of selected mechanics.
/// - [hideDescription]: Controls visibility of descriptions.
/// - [showSelected]: Toggles visibility of selected mechanics.
class MechanicsStore extends StateStore {
  final mechanicManager = getIt<MechanicsManager>();

  List<MechanicModel> selectedMechs = [];

  final counter = ValueNotifier<int>(0);
  final hideDescription = ValueNotifier<bool>(false);
  final showSelected = ValueNotifier<bool>(false);
  final updateMechList = ValueNotifier<bool>(false);

  /// Retrieves the names of all selected mechanics.
  List<String> get mechsNames =>
      selectedMechs.map((mech) => mech.name).toList();

  /// Retrieves the IDs of all selected mechanics.
  List<String> get selectedMechIds =>
      selectedMechs.map((mech) => mech.id!).toList();

  void init(List<String>? mechIds) {
    if (mechIds == null) return;

    selectedMechs.addAll(
      mechanicManager.mechanics.where((mech) => mechIds.contains(mech.id!)),
    );
    counter.value = selectedMechs.length;
  }

  /// Disposes all [ValueNotifier]s to free resources.
  @override
  void dispose() {
    counter.dispose();
    hideDescription.dispose();
    showSelected.dispose();
    updateMechList.dispose();

    super.dispose();
  }

  /// Notifies updates in the mechanics list
  void notifiesUpdateMechList() {
    updateMechList.value = !updateMechList.value;
  }

  /// Toggles the [hideDescription] flag with loading and success states.
  void toggleHideDescription() {
    setStateLoading();
    hideDescription.value = !hideDescription.value;
    Future.delayed(const Duration(microseconds: 50));
    setStateSuccess();
  }

  /// Toggles the [showSelected] flag with loading and success states.
  void toggleShowSelected() {
    setStateLoading();
    final newValue = !showSelected.value;
    if (selectedMechs.isEmpty) {
      showSelected.value = false;
    } else {
      showSelected.value = newValue;
    }

    Future.delayed(const Duration(microseconds: 50));
    setStateSuccess();
  }

  /// Adds or removes a mechanic from [selectedMechs].
  /// Updates [counter] with the current count of selected mechanics.
  void addMech(MechanicModel value) {
    if (!isSelectedId(value.id!)) {
      selectedMechs.add(value);
    } else {
      selectedMechs.removeWhere((mech) => mech.id == value.id);
    }
    counter.value = selectedMechs.length;
  }

  /// Clears all selected mechanics and resets [counter].
  void cleanMech() {
    selectedMechs.clear();
    counter.value = 0;
  }

  /// Checks if a mechanic with the given [id] is selected.
  bool isSelectedId(String id) {
    return selectedMechIds.contains(id);
  }
}
