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

import 'package:sqflite/sqflite.dart';

import 'constants.dart';

class SqlTable {
  SqlTable._();

  static createBgNamesTable(Batch batch) {
    batch.execute(
      'CREATE TABLE IF NOT EXISTS $bgNamesTable ('
      '   $bgId	TEXT PRIMARY KEY NOT NULL,'
      '   $bgName	TEXT NOT NULL'
      ')',
    );
  }

  static createDbVersionTable(Batch batch) {
    batch.execute(
      'CREATE TABLE IF NOT EXISTS $dbVersionTable ('
      '  $dbVersionId	INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
      '  $dbAppVersion	INTEGER NOT NULL,'
      '  $dbBGVersion	INTEGER NOT NULL DEFAULT 0,'
      '  $dbBGList	TEXT NOT NULL DEFAULT "[]"'
      ')',
    );
  }

  static createMechanicsTable(Batch batch) {
    batch.execute(
      'CREATE TABLE IF NOT EXISTS $mechTable ('
      '  $mechId TEXT PRIMARY KEY NOT NULL,'
      '  $mechName TEXT NOT NULL UNIQUE,'
      '  $mechDescription TEXT NOT NULL'
      ')',
    );
  }

  static createBagItemsTable(Batch batch) {
    batch.execute(
      'CREATE TABLE IF NOT EXISTS $bagItemsTable ('
      '  $bagItemsId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
      '  $bagItemsAdId TEXT NOT NULL UNIQUE,'
      '  $bagItemsOwnerId TEXT NOT NULL,'
      '  $bagItemsOwnerName TEXT NOT NULL,'
      '  $bagItemsTitle TEXT NOT NULL,'
      '  $bagItemsDescription TEXT NOT NULL,'
      '  $bagItemsQuantity INTEGER NOT NULL DEFAULT 1,'
      '  $bagItemsUnitPrice REAL NOT NULL DEFAULT 0.0'
      ')',
    );
  }

  static dropMechanicsTable(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS $mechTable');
  }

  static dropBgNamesTable(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS $bgNamesTable');
  }

  static dropBagItemsTable(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS $bagItemsTable');
  }

  static cleanBagItemsTable(Batch batch) {
    batch.execute('DELETE FROM $bagItemsTable');
  }
}
