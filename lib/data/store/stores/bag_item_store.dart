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

import 'package:sqflite/sqflite.dart';

import '../../../core/get_it.dart';
import '../constants/constants.dart';
import '../database/database_manager.dart';
import 'interfaces/i_bag_item_store.dart';

class BagItemStore implements IBagItemStore {
  final _databaseManager = getIt<DatabaseManager>();
  late final Database _db;

  @override
  Future<void> initialize() async {
    _db = await _databaseManager.database;
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    try {
      final result = await _db.query(
        bagItemsTable,
      );

      return result;
    } catch (err) {
      log('BagItemStore.getAll: $err');
      return [];
    }
  }

  @override
  Future<int> add(Map<String, dynamic> map) async {
    try {
      final id = await _db.insert(
        bagItemsTable,
        map,
      );

      return id;
    } catch (err) {
      log('BagItemStore.add: $err');
      return -1;
    }
  }

  @override
  Future<int> update(Map<String, dynamic> map) async {
    try {
      final id = map[bagItemsId]!;
      final result = await _db.update(
        bagItemsTable,
        map,
        where: '$bagItemsId = ?',
        whereArgs: [id],
      );

      return result;
    } catch (err) {
      log('BagItemStore.update: $err');
      return -1;
    }
  }

  @override
  Future<int> updateQuantity(int id, int quantity) async {
    try {
      final result = await _db.update(
        bagItemsTable,
        {bagItemsQuantity: quantity},
        where: '$bagItemsId = ?',
        whereArgs: [id],
      );

      return result;
    } catch (err) {
      log('BagItemStore.updateQuantity: $err');
      return -1;
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      final result = await _db.delete(
        bagItemsTable,
        where: '$bagItemsId = ?',
        whereArgs: [id],
      );

      return result;
    } catch (err) {
      log('BagItemStore.delete: $err');
      return -1;
    }
  }

  @override
  Future<void> resetDatabase() async {
    await _databaseManager.resetBagItemsTable(_db);
  }

  @override
  Future<void> cleanDatabase() async {
    await _databaseManager.cleanBagItems(_db);
  }
}
