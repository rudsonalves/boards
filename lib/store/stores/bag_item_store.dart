import 'dart:developer';

import 'package:sqflite/sqflite.dart';

import '/get_it.dart';
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
