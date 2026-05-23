import 'package:shared_preferences/shared_preferences.dart';

/// Thin, testable wrapper around [SharedPreferences].
///
/// It is the single low-level persistence dependency of the app and is injected
/// into every local datasource through `get_it`. Reads are synchronous (the
/// preferences are loaded once at boot); writes are async.
class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  /// Loads the backing store. Call once during bootstrap (see `di.dart`).
  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  int? getInt(String key) => _prefs.getInt(key);
  Future<void> setInt(String key, int value) => _prefs.setInt(key, value);

  double? getDouble(String key) => _prefs.getDouble(key);
  Future<void> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);

  String? getString(String key) => _prefs.getString(key);
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  bool? getBool(String key) => _prefs.getBool(key);
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  Future<void> remove(String key) => _prefs.remove(key);
}
