import 'package:shared_preferences/shared_preferences.dart';

import '../interfaces/i_app_preferences_repository.dart';

class AppSharePreferencesRepository implements IAppPreferencesRepository {
  late final SharedPreferences prefs;
  bool started = false;

  static const keySearchHistory = 'SearchHistory';
  static const keyLocalDBVersion = 'LocalDBVersion';
  static const keyBrightness = 'Brightness';

  @override
  late int dbVersion;

  @override
  late String brightness;

  @override
  late List<String> history;

  @override
  Future<void> initialize() async {
    if (started) return;

    started = true;
    prefs = await SharedPreferences.getInstance();
    dbVersion = prefs.getInt(keyLocalDBVersion) ?? 1000;
    brightness = prefs.getString(keyBrightness) ?? 'dark';
    history = prefs.getStringList(keySearchHistory) ?? [];
  }

  @override
  Future<void> setBright(String value) async {
    brightness = value;
    prefs.setString(keyBrightness, brightness);
  }

  @override
  Future<void> setDBVersion(int value) async {
    dbVersion = value;
    prefs.setInt(keyLocalDBVersion, dbVersion);
  }

  @override
  Future<void> setHistory(List<String> value) async {}
}
