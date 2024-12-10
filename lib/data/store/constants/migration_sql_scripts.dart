// import 'constants.dart';

import 'constants.dart';

class MigrationSqlScripts {
  MigrationSqlScripts._();

  static const localDBVersion = 1001;
  // FIXME: Check by db version in AppSettoings.localDBVersion!

  static const Map<int, List<String>> sqlMigrationsScripts = {
    1000: [],
    1001: [
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
    ],
  };
}
