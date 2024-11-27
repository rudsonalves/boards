import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '/store/constants/sql_create_table.dart';
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

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      await _copyBggDb(path);
    }

    _database = await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreate,
      // onConfigure: _onConfiguration,
    );

    return _database!;
  }

  Future<void> _copyBggDb(String path) async {
    final file = await File(path).create();
    ByteData data = await rootBundle.load(dbAssertPath);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await file.writeAsBytes(bytes);
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

  Future<void> resetMechanics(Database db) async {
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

  Future<void> resetBagItems(Database db) async {
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
