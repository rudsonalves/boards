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

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseUtil {
  DatabaseUtil._();

  static Future<Directory> getDirectory() async {
    final baseDir = await getApplicationDocumentsDirectory();
    String basePath = '';
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      basePath = 'App/bgBazzar';
    } else if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }
    final directory =
        basePath.isEmpty ? baseDir : Directory(join(baseDir.path, basePath));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }
}
