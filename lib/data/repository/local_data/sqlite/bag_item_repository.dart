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

import '../../../../core/get_it.dart';
import '../../../models/bag_item.dart';
import '../common/local_functions.dart';
import '/core/abstracts/data_result.dart';
import '../../../store/stores/interfaces/i_bag_item_store.dart';
import '../../interfaces/local/i_local_bag_item_repository.dart';

class SqliteBagItemRepository implements ILocalBagItemRepository {
  late IBagItemStore _store;

  @override
  Future<void> initialize() async {
    _store = await getIt.getAsync<IBagItemStore>();
  }

  @override
  Future<DataResult<List<BagItemModel>>> getAll() async {
    try {
      final maps = await _store.getAll();
      if (maps.isEmpty) {
        return DataResult.success([]);
      }

      final bagItems = maps.map((map) => BagItemModel.fromMap(map)).toList();
      return DataResult.success(bagItems);
    } catch (err) {
      return _handleError('getAll', err);
    }
  }

  @override
  Future<DataResult<BagItemModel>> add(BagItemModel bagItem) async {
    try {
      final id = await _store.add(bagItem.toMap());
      if (id < 0) throw Exception('resturn id $id');

      return DataResult.success(bagItem.copyWith(id: id));
    } catch (err) {
      return _handleError('add', err);
    }
  }

  @override
  Future<DataResult<void>> delete(int id) async {
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
  Future<DataResult<int>> update(BagItemModel bagItem) async {
    try {
      final result = await _store.update(bagItem.toMap());
      return DataResult.success(result);
    } catch (err) {
      return _handleError('update', err);
    }
  }

  @override
  Future<DataResult<int>> updateQuantity(BagItemModel bagItem) async {
    try {
      final result = await _store.updateQuantity(bagItem.id!, bagItem.quantity);
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

  @override
  Future<DataResult<void>> cleanDatabase() async {
    try {
      await _store.cleanDatabase();
      return DataResult.success(null);
    } catch (err) {
      return _handleError('cleanDatabase', err);
    }
  }

  static DataResult<T> _handleError<T>(String module, Object error) {
    return LocalFunctions.handleError('SqliteBagItemRepository', module, error);
  }
}
