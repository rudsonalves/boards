import 'dart:developer';

import '/core/models/mechanic.dart';
import '/get_it.dart';
import '/data_managers/mechanics_manager.dart';
import 'mechanics_store.dart';

/// Controls the mechanics state by managing selections and interactions with
/// the mechanics store and mechanics manager.
class MechanicsController {
  late final MechanicsStore store;
  final mechanicManager = getIt<MechanicsManager>();

  /// Initializes the controller with the provided [store] and a list of [psIds].
  void init(MechanicsStore store) {
    this.store = store;
  }

  /// Adds a mechanic to the database and updates the store's state.
  /// Sets loading, success, and error states as appropriate.
  Future<void> add(MechanicModel mech) async {
    try {
      store.setStateLoading();
      await mechanicManager.add(mech);
      store.notifiesUpdateMechList();
      store.setStateSuccess();
    } catch (err) {
      log('add mechanic error: $err');
      store.setError('Erro ao adicionar uma mecânica.');
    }
  }

  Future<void> update(MechanicModel mech) async {
    try {
      store.setStateLoading();
      await mechanicManager.update(mech);
      store.notifiesUpdateMechList();
      store.setStateSuccess();
    } catch (err) {
      log('add mechanic error: $err');
      store.setError('Erro ao adicionar uma mecânica.');
    }
  }

  /// Selects a mechanic by its [name]. If found, adds it to the store's
  /// selected list.
  void selectMechByName(String name) {
    if (name.isEmpty) return;
    final MechanicModel mech = mechanicManager.mechanics.firstWhere(
      (mech) => mech.name == name,
      orElse: () => MechanicModel(name: ''),
    );
    if (mech.id == null) return;
    store.setStateLoading();
    store.addMech(mech);
    store.setStateSuccess();
  }

  /// Deselects all selected mechanics in the store.
  void deselectAll() {
    store.setStateLoading();
    store.cleanMech();
    store.setStateSuccess();
  }

  /// Sets the store state to success, typically called after a dialog is
  /// closed.
  void closeDialog() {
    store.setStateSuccess();
  }

  Future<bool> removeMechs(MechanicModel mech) async {
    try {
      store.setStateLoading();
      await mechanicManager.delete(mech);
      store.notifiesUpdateMechList();
      store.setStateSuccess();
      return true;
    } catch (err) {
      store.setError('Teve algum problema no servidor. Tente mais tarde.');
      return false;
    }
  }
}
