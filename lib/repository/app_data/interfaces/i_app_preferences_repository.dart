abstract class IAppPreferencesRepository {
  late int dbVersion;
  late String brightness;
  late List<String> history;

  Future<void> initialize();
  Future<void> setBright(String value);
  Future<void> setDBVersion(int value);
  Future<void> setHistory(List<String> value);
}
