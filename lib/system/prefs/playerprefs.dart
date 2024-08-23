import 'package:flutter_corelib/flutter_corelib.dart';

class PlayerPrefs {
  static SharedPreferences? _prefs;
  static bool _isInit = false;
  static Logger _logger = Logger('PlayerPrefs');

  static Future<void> init() async {
    if (_isInit) return;
    _isInit = true;
    _prefs ??= await SharedPreferences.getInstance();
  }

  static void _checkPrefs() {
    if (_prefs == null) {
      _logger.severe('PlayerPrefs is not initialized');
    }
  }

  static void setString(String key, String value) async {
    _checkPrefs();
    _prefs?.setString(key, value);
  }

  static String getString(String key, {String defaultValue = ''}) {
    _checkPrefs();
    return _prefs?.getString(key) ?? defaultValue;
  }

  static void setInt(String key, int value) async {
    _checkPrefs();
    _prefs?.setInt(key, value);
  }

  static int getInt(String key, {int defaultValue = 0}) {
    _checkPrefs();
    return _prefs?.getInt(key) ?? defaultValue;
  }

  static void setDouble(String key, double value) async {
    _checkPrefs();
    _prefs?.setDouble(key, value);
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    _checkPrefs();
    return _prefs?.getDouble(key) ?? defaultValue;
  }

  static void setBool(String key, bool value) async {
    _checkPrefs();
    _prefs?.setBool(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    _checkPrefs();
    return _prefs?.getBool(key) ?? defaultValue;
  }

  static void setStringList(String key, List<String> value) async {
    _checkPrefs();
    _prefs?.setStringList(key, value);
  }

  static List<String> getStringList(String key, {List<String> defaultValue = const []}) {
    _checkPrefs();
    return _prefs?.getStringList(key) ?? defaultValue;
  }

  static void remove(String key) {
    _checkPrefs();
    _prefs?.remove(key);
  }

  static void debugLogAllKeys() {
    _checkPrefs();
    for (String key in _prefs!.getKeys()) {
      _logger.info('key: $key, value: ${_prefs!.get(key)}');
    }
  }
}
