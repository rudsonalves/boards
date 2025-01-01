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
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../constants/sql_create_table.dart';
import '../constants/constants.dart';
import 'database_util.dart';

class DatabaseManager {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
    _database = null;
  }

  Future<Database> _initDatabase() async {
    // String basePath = '';
    // if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    //   sqfliteFfiInit();
    //   databaseFactory = databaseFactoryFfi;
    //   basePath = 'App/bgBazzar';
    // } else if (kIsWeb) {
    //   databaseFactory = databaseFactoryFfiWeb;
    // }
    // final baseDir = await getApplicationDocumentsDirectory();
    // final directory =
    //     basePath.isEmpty ? baseDir : Directory(join(baseDir.path, basePath));
    // if (!await directory.exists()) {
    //   await directory.create(recursive: true);
    // }
    final Directory directory = await DatabaseUtil.getDirectory();
    final path = join(directory.path, dbName);

    // if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
    //   await _copyBggDb(path);
    // }

    _database = await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreate,
      // onConfigure: _onConfiguration,
    );

    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      Batch batch = db.batch();
      SqlTable.createDbVersionTable(batch);
      SqlTable.createBgNamesTable(batch);
      SqlTable.createMechanicsTable(batch);
      SqlTable.createBagItemsTable(batch);

      await batch.commit();
    } catch (err) {
      log(err.toString());
    }
  }

  // Future<void> _onConfiguration(Database db) async {
  //   await db.execute('PRAGMA foreign_keys = ON');
  // }

  Future<int?> getDBVerion() async {
    try {
      final result = await _database!.query(
        dbVersionTable,
        columns: [dbAppVersion],
        where: '$dbVersionId = 1',
      );
      return result.first[dbAppVersion] as int;
    } catch (err) {
      return null;
    }
  }

  Future<void> resetDatabase() async {
    final db = _database!;
    await resetMechanicsTable(db);
    await resetBgNamesTable(db);
    await resetBagItemsTable(db);
  }

  Future<void> resetMechanicsTable(Database db) async {
    try {
      Batch batch = db.batch();
      SqlTable.dropMechanicsTable(batch);
      SqlTable.createMechanicsTable(batch);

      await batch.commit();
    } catch (err) {
      log(err.toString());
    }
  }

  Future<void> resetBgNamesTable(Database db) async {
    try {
      Batch batch = db.batch();
      SqlTable.dropBgNamesTable(batch);
      SqlTable.createBgNamesTable(batch);

      await batch.commit();
    } catch (err) {
      log(err.toString());
    }
  }

  Future<void> resetBagItemsTable(Database db) async {
    try {
      Batch batch = db.batch();
      SqlTable.dropBagItemsTable(batch);
      SqlTable.createBagItemsTable(batch);

      await batch.commit();
    } catch (err) {
      log(err.toString());
    }
  }

  Future<void> cleanBagItems(Database db) async {
    try {
      Batch batch = db.batch();
      SqlTable.cleanBagItemsTable(batch);

      await batch.commit();
    } catch (err) {
      log(err.toString());
    }
  }
}
