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

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';

import '/core/get_it.dart';
import '/core/abstracts/data_result.dart';
import '/data/models/mechanic.dart';
import '/data/repository/interfaces/remote/i_mechanic_repository.dart';
import '/data/repository/interfaces/local/i_local_mechanic_repository.dart';

enum ManagerStatus { ok, error, duplicated }

/// This class manages the list of mechanics, providing methods to initialize,
/// retrieve mechanic names, and find mechanic names based on their IDs.
class MechanicsManager {
  final mechRepository = getIt<IMechanicRepository>();
  late final ILocalMechanicRepository localMechRepository;

  final List<MechanicModel> _mechanics = [];

  List<MechanicModel> get mechanics => _mechanics;
  List<String> get mechanicsNames =>
      _mechanics.map((item) => item.name).toList();

  Future<void> initialize() async {
    localMechRepository = await getIt.getAsync<ILocalMechanicRepository>();
    await getAllMechanics();
  }

  Future<void> getAllMechanics() async {
    final localResult = await localMechRepository.getAll();
    if (localResult.isFailure) {
      throw Exception(localResult.error);
    }

    final mechs = localResult.data!;

    _mechanics.clear();
    if (mechs.isNotEmpty) {
      _mechanics.addAll(mechs);
    }

    final result = await mechRepository.getAll();
    if (result.isFailure ||
        result.data == null ||
        result.data!.length == _mechanics.length) {
      return;
    }

    final dbMechs = result.data!;

    final localIds = _mechanics.map((m) => m.id).toList();
    for (final mech in dbMechs) {
      if (!localIds.contains(mech.id)) {
        final localResult = await localMechRepository.add(mech);
        if (localResult.isFailure) {
          throw Exception(localResult.error);
        }

        final newMech = localResult.data!;

        _mechanics.add(newMech);
      }
    }
  }

  /// Returns the name of the mechanic given its ID.
  ///
  /// [mechId] - The ID of the mechanic.
  /// Returns the name of the mechanic if found, otherwise returns null.
  String? nameFromMechId(String mechId) {
    return _mechanics
        .firstWhere(
          (item) => item.id == mechId,
          orElse: () => MechanicModel(id: null, name: ''),
        )
        .name;
  }

  /// Returns a list of mechanic names given a list of mechanic IDs.
  ///
  /// [mechIds] - A list of mechanic IDs.
  /// Returns a list of mechanic names corresponding to the provided IDs.
  /// If a mechanic ID does not correspond to a mechanic, it logs an error.
  List<String> namesFromMechIdList(List<String> mechIds) {
    List<String> names = [];
    for (final mechId in mechIds) {
      final name = nameFromMechId(mechId);
      if (name != null) {
        names.add(name);
        continue;
      }
      log('MechanicsManager.namesFromIdList: name from'
          ' MechanicModel.id $mechId return erro');
    }

    return names;
  }

  MechanicModel mechFromId(String mechId) {
    return _mechanics.firstWhere((m) => m.id! == mechId);
  }

  String namesFromIdListString(List<String> psIds) {
    return namesFromMechIdList(psIds)
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');
  }

  MechanicModel mechanicOfMechId(String psId) {
    return _mechanics.firstWhere((item) => item.id == psId);
  }

  MechanicModel? mechanicOfName(String name) {
    final mech = _mechanics.firstWhere((item) => item.name == name,
        orElse: () => MechanicModel(name: ''));
    return mech.id != null ? mech : null;
  }

  Future<ManagerStatus> add(MechanicModel mech) async {
    // add in parse server database
    final newMech = await _addMechanicData(mech);
    if (newMech == null || newMech.id == null) return ManagerStatus.error;

    // add in local database
    final result = await _addLocalMechanicData(newMech);
    if (result == null) {
      return ManagerStatus.error;
    }

    _mechanics.add(newMech);
    _sortingMechsNames();
    return ManagerStatus.ok;
  }

  Future<DataResult<void>> updateWithCSV(String csvFile) async {
    try {
      final File file = File(csvFile);
      final input = file.openRead();

      // Decoding CSV
      final data = await input
          .transform(utf8.decoder)
          .transform(CsvToListConverter(
            eol: '\n',
          ))
          .toList();

      final mechs = data
          .map((item) => MechanicModel(
                name: item[0],
                description: item[1],
              ))
          .toList();

      final names = mechanicsNames;
      for (final mech in mechs) {
        if (mech.name == 'name') continue;

        if (!names.contains(mech.name)) {
          await add(mech);
          names.add(mech.name);
          log('Add mechanic: "${mech.name}"');
        } else {
          final index = _mechanics.indexWhere((m) => mech.name == m.name);
          if (_mechanics[index].description != mech.description) {
            final updateMech = mech.copyWith(id: _mechanics[index].id);
            await update(updateMech);
            log('Update mechanic: "${mech.name}"');
          } else {
            log('Skip mechanic: "${mech.name}"');
          }
        }
      }
      return DataResult.success(null);
    } catch (err) {
      return DataResult.failure(GenericFailure(message: err.toString()));
    }
  }

  Future<ManagerStatus> delete(MechanicModel mech) async {
    // return erro if mechanic don't have id
    if (mech.id == null) {
      log('MechanicsManager.delete: mechanic id is null');
      return ManagerStatus.error;
    }
    // remove mechanic from database
    final result = await mechRepository.delete(mech.id!);
    if (result.isFailure) {
      log('MechanicsManager.delete: I can not remove mechanic: ${result.error}');
      return ManagerStatus.error;
    }

    // remove mechanic from local data
    final localResult = await localMechRepository.delete(mech.id!);
    if (localResult.isFailure) {
      return ManagerStatus.error;
    }

    // remove mechanic from memory list
    _mechanics.removeWhere((m) => m.id == mech.id);
    return ManagerStatus.ok;
  }

  Future<DataResult<void>> update(MechanicModel mech) async {
    final result = await mechRepository.update(mech);
    if (result.isFailure) {
      return result;
    }

    final localResult = await localMechRepository.update(mech);
    if (localResult.isFailure) {
      return localResult;
    }

    int index = _mechanics.indexWhere((m) => m.id == mech.id);
    if (index == -1) {
      return DataResult.failure(
          GenericFailure(message: 'MechanicsManager.update: index error'));
    }
    _mechanics[index] = mech;

    return DataResult.success(null);
  }

  Future<DataResult<MechanicModel>> get(String mechId) async {
    return await mechRepository.get(mechId);
  }

  Future<DataResult<void>> resetLocalDatabase() async {
    try {
      final localResult = await localMechRepository.resetDatabase();
      if (localResult.isFailure) {
        throw Exception(localResult.error);
      }

      _mechanics.clear();

      return DataResult.success(null);
    } catch (err) {
      final message = 'MechanicsManager.resetDatabase: $err';
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  Future<DataResult<List<MechanicModel>>> getAll() async {
    try {
      final result = await mechRepository.getAll();
      if (result.isFailure) {
        throw Exception(result.error);
      }

      return result;
    } catch (err) {
      return DataResult.failure(GenericFailure(message: err.toString()));
    }
  }

  Future<DataResult<void>> addLocalDatabase(MechanicModel mech) async {
    try {
      final result = await localMechRepository.add(mech);
      if (result.isFailure) {
        throw Exception(result.error);
      }

      return DataResult.success(null);
    } catch (err) {
      final message = 'MechanicsManager.addLocalDatabase: $err';
      return DataResult.failure(GenericFailure(message: message));
    }
  }

  // Add mechanic in local sqlite database
  Future<MechanicModel?> _addLocalMechanicData(MechanicModel mech) async {
    if (mechanicsNames.contains(mech.name)) return null;
    if (mech.id == null) return null;

    final result = await localMechRepository.add(mech);
    if (result.isFailure) {
      log(result.error?.toString() ?? 'unknow error');
      return null;
    }

    return result.data;
  }

  // Add mechanic in parse server database
  Future<MechanicModel?> _addMechanicData(MechanicModel mech) async {
    final result = await mechRepository.add(mech);
    if (result.isFailure) {
      throw Exception(result.error);
    }
    return result.data;
  }

  void _sortingMechsNames() {
    List<String> names = mechanicsNames;
    names.sort();
    final List<MechanicModel> sortMechList = [];
    for (final name in names) {
      sortMechList.add(_mechanics.firstWhere((m) => m.name == name));
    }
    _mechanics.clear();
    _mechanics.addAll(sortMechList);
  }
}
