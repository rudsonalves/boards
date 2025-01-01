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

import '../../../../core/get_it.dart';
import '../../constants/migration_sql_scripts.dart';
import '/core/singletons/app_settings.dart';

class DatabaseMigration {
  DatabaseMigration._();

  static Future<void> applyMigrations({
    required Database db,
  }) async {
    final appSettings = getIt<AppSettings>();

    try {
      // await db.execute('PRAGMA foreign_keys=off');
      for (var version = appSettings.localDBVersion + 1;
          version <= MigrationSqlScripts.localDBVersion;
          version++) {
        log('Database migrating to version: $version');
        final bach = db.batch();
        final scripts = MigrationSqlScripts.sqlMigrationsScripts[version];
        if (scripts != null && scripts.isNotEmpty) {
          for (final script in scripts) {
            bach.execute(script);
          }
        }
        await bach.commit(noResult: true);
        appSettings.setLocalDBVersion(version);
      }
      // await db.execute('PRAGMA foreign_keys=on');
    } catch (err) {
      final message = 'DatabaseMigration.applyMigrations: $err';
      log(message);
      rethrow;
    }
  }
}
