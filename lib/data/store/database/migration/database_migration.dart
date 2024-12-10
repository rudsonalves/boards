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
