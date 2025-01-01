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

import 'package:flutter/material.dart';

import '../get_it.dart';
import '../../data/repository/interfaces/remote/i_app_preferences_repository.dart';

class AppSettings {
  final prefs = getIt<IAppPreferencesRepository>();

  final ValueNotifier<Brightness> _brightness =
      ValueNotifier<Brightness>(Brightness.dark);

  int _localDBVersion = 1001;

  ValueNotifier<Brightness> get brightness => _brightness;
  bool get isDark => _brightness.value == Brightness.dark;
  int get localDBVersion => _localDBVersion;

  Future<void> init() async {
    await prefs.initialize();
    await _readAppSettings();
  }

  Future<void> _readAppSettings() async {
    _localDBVersion = prefs.dbVersion;

    _brightness.value =
        prefs.brightness == 'dark' ? Brightness.dark : Brightness.light;
  }

  Future<void> _saveBright() async {
    prefs.setBright(_brightness.value == Brightness.dark ? 'dark' : 'light');
  }

  Future<void> setLocalDBVersion(int version) async {
    _localDBVersion = version;
    prefs.setDBVersion(version);
  }

  void toggleBrightnessMode() {
    _brightness.value = _brightness.value == Brightness.dark
        ? Brightness.light
        : Brightness.dark;
    _saveBright();
  }

  void dispose() {
    _brightness.dispose();
  }
}
