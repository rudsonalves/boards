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
