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

import 'interfaces/i_mechanics_store.dart';
import '../../../core/get_it.dart';
import '../constants/constants.dart';
import '../database/database_manager.dart';

class MechanicsStore implements IMechanicsStore {
  final _databaseManager = getIt<DatabaseManager>();
  late final Database _db;

  @override
  Future<void> initialize() async {
    _db = await _databaseManager.database;
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    try {
      List<Map<String, dynamic>> result = await _db.query(
        mechTable,
        columns: [mechId, mechName, mechDescription],
        orderBy: mechName,
      );

      return result;
    } catch (err) {
      log('MechanicsStore.getAll: $err');
      return [];
    }
  }

  @override
  Future<int> add(Map<String, dynamic> map) async {
    try {
      final result = await _db.insert(
        mechTable,
        map,
      );

      return result;
    } catch (err) {
      log('MechanicsStore.add: $err');
      return -1;
    }
  }

  @override
  Future<int> update(Map<String, dynamic> map) async {
    try {
      final result = await _db.update(
        mechTable,
        map,
      );

      return result;
    } catch (err) {
      log('MechanicsStore.update: $err');
      return -1;
    }
  }

  @override
  Future<int> delete(String id) async {
    try {
      final result = await _db.delete(
        mechTable,
        where: '$mechId = ?',
        whereArgs: [id],
      );

      return result;
    } catch (err) {
      log('MechanicsStore.delete: $err');
      return -1;
    }
  }

  @override
  Future<void> resetDatabase() async {
    await _databaseManager.resetMechanicsTable(_db);
  }
}
