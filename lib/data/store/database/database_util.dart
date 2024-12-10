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
