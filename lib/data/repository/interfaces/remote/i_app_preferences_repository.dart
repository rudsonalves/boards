/// A repository for managing application preferences using SharedPreferences.
///
/// This class provides methods to initialize, retrieve, and update preferences
/// such as search history, database version, and brightness settings.
///
/// ### Dependencies:
/// - [SharedPreferences]: Used to persist preferences.
/// - [IAppPreferencesRepository]: Interface that this class implements.
abstract class IAppPreferencesRepository {
  /// Holds the local database scheme version, defaulting to `1000` if not set.
  late int dbVersion;

  /// Holds the application's brightness setting, defaulting to `'dark'` if not
  /// set.
  late String brightness;

  /// Holds a list of search history strings, defaulting to an empty list if
  /// not set.
  late List<String> history;

  /// Initializes the repository by loading preferences from SharedPreferences.
  ///
  /// This method ensures that the repository is initialized only once. It
  /// retrieves stored values for database version, brightness, and search
  /// history, applying default values if none are found.
  ///
  /// Throws:
  /// - Any error that occurs during initialization.
  Future<void> initialize();

  /// Updates the brightness preference in memory and persists it to S
  /// haredPreferences.
  ///
  /// Parameters:
  /// - `value`: A string representing the brightness value (e.g., `'dark'`,
  /// `'light'`).
  ///
  /// Throws:
  /// - Any error that occurs while writing to SharedPreferences.
  Future<void> setBright(String value);

  /// Updates the local database version in memory and persists it to
  /// SharedPreferences.
  ///
  /// Parameters:
  /// - `value`: An integer representing the database version.
  ///
  /// Throws:
  /// - Any error that occurs while writing to SharedPreferences.
  Future<void> setDBVersion(int value);

  /// Updates the search history in memory and persists it to SharedPreferences.
  ///
  /// Parameters:
  /// - `value`: A list of strings representing the search history.
  ///
  /// Note:
  /// - This method is not yet implemented.
  Future<void> setHistory(List<String> value);
}
