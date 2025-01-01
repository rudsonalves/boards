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

import 'dart:developer';

import '../../../../data/models/mechanic.dart';
import '../../../../core/get_it.dart';
import '../../../../logic/managers/mechanics_manager.dart';
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

  Future<void> importCSV(String csvFile) async {
    try {
      store.setStateLoading();
      await mechanicManager.updateWithCSV(csvFile);
      store.setStateSuccess();
    } catch (err) {
      store.setError('Teve algum problema no servidor. Tente mais tarde.');
    }
  }
}
