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
