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
