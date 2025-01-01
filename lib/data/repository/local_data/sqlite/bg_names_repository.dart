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

import '../common/local_functions.dart';
import '/core/abstracts/data_result.dart';
import '../../../../core/get_it.dart';
import '../../../models/bg_name.dart';
import '../../../store/stores/interfaces/i_bg_names_store.dart';
import '../../interfaces/remote/i_bg_names_repository.dart';

class SqliteBGNamesRepository implements IBgNamesRepository {
  late final IBgNamesStore _store;

  @override
  Future<void> initialize() async {
    _store = await getIt.getAsync<IBgNamesStore>();
  }

  @override
  Future<DataResult<List<BGNameModel>>> getAll() async {
    try {
      final maps = await _store.getAll();
      if (maps.isEmpty) {
        return DataResult.success([]);
      }

      final bgs = maps.map((item) => BGNameModel.fromMap(item)).toList();
      return DataResult.success(bgs);
    } catch (err) {
      return _handleError('getAll', err);
    }
  }

  @override
  Future<DataResult<BGNameModel>> add(BGNameModel bg) async {
    try {
      final id = await _store.add(bg.toMap());
      if (id < 0) throw Exception('retrun id $id');

      return DataResult.success(bg);
    } catch (err) {
      return _handleError('add', err);
    }
  }

  @override
  Future<DataResult<void>> delete(String id) async {
    try {
      final result = await _store.delete(id);
      if (result < 1) {
        throw Exception('record not found');
      }
      return DataResult.success(null);
    } catch (err) {
      return _handleError('delete', err);
    }
  }

  @override
  Future<DataResult<int>> update(BGNameModel bg) async {
    try {
      final result = await _store.update(bg.toMap());
      return DataResult.success(result);
    } catch (err) {
      return _handleError('update', err);
    }
  }

  @override
  Future<DataResult<void>> resetDatabase() async {
    try {
      await _store.resetDatabase();
      return DataResult.success(null);
    } catch (err) {
      return _handleError('resetDatabase', err);
    }
  }

  static DataResult<T> _handleError<T>(String module, Object error) {
    return LocalFunctions.handleError('SqliteBGNamesRepository', module, error);
  }
}
