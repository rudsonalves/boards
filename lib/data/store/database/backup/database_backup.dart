import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';

import '../../../../core/get_it.dart';
import '../database_manager.dart';
import '../../constants/constants.dart';
import '../database_util.dart';

class DatabaseBackup {
  DatabaseBackup._();
  static final _databaseManager = getIt<DatabaseManager>();

  /// Creates a backup of the current database.
  ///
  /// Optionally, a [destinyDir] can be specified to store the backup.
  /// Returns the path to the backup file if successful, `null` otherwise.
  static Future<bool> backupDatabase() async {
    try {
      final dir = await DatabaseUtil.getDirectory();
      final originalPath = join(dir.path, dbName);
      String backupPath = _backupFilaname(dir);

      final dbBackupFile = File(backupPath);
      if (await dbBackupFile.exists()) {
        await dbBackupFile.delete();
      }

      final File dbFile = File(originalPath);
      await dbFile.copy(backupPath);

      return true;
    } catch (err) {
      final message = 'DatabaseBackup.backupDatabase: $err';
      log(message);
      return false;
    }
  }

  static String _backupFilaname(Directory dir) => join(dir.path, '$dbName.bkp');

  /// Restores the database from a backup file.
  ///
  /// Returns `true` if the restoration is successful, `false` otherwise.
  static Future<bool> restoreDatabase() async {
    final database = await _databaseManager.database;
    final dir = await DatabaseUtil.getDirectory();
    final originalPath = join(dir.path, dbName);
    final backupPath = _backupFilaname(dir);

    try {
      // Close database before replace it
      await _databaseManager.close();

      // Copy original file to backup path
      final File originalFile = File(originalPath);
      await originalFile.delete();

      // Remove original database
      await originalFile.delete();

      // Replace original database by new one, and open a new database
      await File(backupPath).copy(originalPath);

      // Open database
      await _databaseManager.database;

      return true;
    } catch (err) {
      final message = 'DatabaseBackup.restoreDatabase: $err';
      log(message);

      // get backup file
      final File backupFile = File(backupPath);
      if (await backupFile.exists()) {
        // Check if database is open and close it
        if (database.isOpen) await _databaseManager.close();
        // Copy backup database to original path
        await backupFile.copy(originalPath);
        // Reopen database file
        await _databaseManager.database;
        // Remove backup file
        await backupFile.delete();
      }
      return false;
    }
  }
}
