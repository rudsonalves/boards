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

import '/core/singletons/app_settings.dart';
import '../../../../core/get_it.dart';
import '../../constants/migration_sql_scripts.dart';
import '../backup/database_backup.dart';
import '../database_manager.dart';
import '../migration/database_migration.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static Future<void> initialize() async {
    final database = await getIt<DatabaseManager>().database;

    final app = getIt<AppSettings>();
    await app.init();

    final isBackuped = await DatabaseBackup.backupDatabase();
    try {
      if (!isBackuped) {
        throw Exception('backup error');
      }
      if (MigrationSqlScripts.localDBVersion > app.localDBVersion) {
        await DatabaseMigration.applyMigrations(db: database);
      }
    } catch (err) {
      final message = 'DatabaseProvider.init: $err';
      if (isBackuped) {
        await DatabaseBackup.restoreDatabase();
      }
      log(message);
      rethrow;
    }
  }
}
