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
