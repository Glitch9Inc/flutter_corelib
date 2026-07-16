import 'dart:convert';

import 'package:flutter_corelib/flutter_corelib.dart';

abstract class FlutterPrefs {
  static SharedPreferences? _prefs;
  static bool _isInit = false;
  static final Logger _logger = Logger('FlutterPrefs');

  static Future<void> ensureInitialized() async {
    if (_isInit) return;
    _isInit = true;
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences getPrefs() {
    if (!_isInit || _prefs == null) {
      _logger.severe('FlutterPrefs is not initialized');
    }

    return _prefs!;
  }

  static bool _checkPrefs() {
    if (_prefs == null) {
      _logger.severe('FlutterPrefs is not initialized');
      return false;
    }
    return true;
  }

  static Future<void> setString(String key, String value) async {
    if (!_checkPrefs()) return;
    _prefs?.setString(key, value);
  }

  static String getString(String key, {String defaultValue = ''}) {
    return getStringOrNull(key) ?? defaultValue;
  }

  static String? getStringOrNull(String key) {
    if (!_checkPrefs()) return null;
    return _prefs?.getString(key);
  }

  static DateTime? getDateTime(String key, {DateTime? defaultValue}) {
    if (!_checkPrefs()) return defaultValue;
    final int? value = _prefs?.getInt(key);
    if (value == null) return defaultValue;
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  static Future<void> setDateTime(String key, DateTime value) async {
    if (!_checkPrefs()) return;
    _prefs?.setInt(key, value.millisecondsSinceEpoch);
  }

  static Future<void> setInt(String key, int value) async {
    if (!_checkPrefs()) return;
    _prefs?.setInt(key, value);
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return getIntOrNull(key) ?? defaultValue;
  }

  static int? getIntOrNull(String key) {
    if (!_checkPrefs()) return null;
    return _prefs?.getInt(key);
  }

  static Future<void> setIntList(String key, List<int> value) async {
    if (!_checkPrefs()) return;
    _prefs?.setStringList(key, value.map((int value) => value.toString()).toList());
  }

  static List<int> getIntList(String key, {List<int> defaultValue = const []}) {
    if (!_checkPrefs()) return defaultValue;
    var stringList = _prefs?.getStringList(key);
    if (stringList == null) {
      return defaultValue;
    }
    return stringList.map((String value) => int.parse(value)).toList();
  }

  static Future<void> setDouble(String key, double value) async {
    if (!_checkPrefs()) return;
    _prefs?.setDouble(key, value);
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    return getDoubleOrNull(key) ?? defaultValue;
  }

  static double? getDoubleOrNull(String key) {
    if (!_checkPrefs()) return null;
    return _prefs?.getDouble(key);
  }

  static Future<void> setBool(String key, bool value) async {
    if (!_checkPrefs()) return;
    _prefs?.setBool(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return getBoolOrNull(key) ?? defaultValue;
  }

  static bool? getBoolOrNull(String key) {
    if (!_checkPrefs()) return null;
    return _prefs?.getBool(key);
  }

  static TEnum getEnum<TEnum extends Enum>(String key, List<TEnum> values, {TEnum? defaultValue}) {
    return getEnumOrNull(key, values) ?? defaultValue!;
  }

  static TEnum? getEnumOrNull<TEnum extends Enum>(String key, List<TEnum> values) {
    if (!_checkPrefs()) return null;
    final int? value = _prefs?.getInt(key);
    if (value == null) {
      return null;
    }
    return EnumConverter.indexToEnum(value, values);
  }

  static Future<void> setEnum<TEnum extends Enum>(String key, TEnum value) async {
    if (!_checkPrefs()) return;
    _prefs?.setInt(key, EnumConverter.enumToIndex(value));
  }

  static List<TEnum> getEnumList<TEnum extends Enum>(String key, List<TEnum> values, {List<TEnum> defaultValue = const []}) {
    if (!_checkPrefs()) return defaultValue;
    return EnumConverter.flagToEnumList(_prefs?.getInt(key) ?? 0, values);
  }

  static Future<void> setEnumList<TEnum extends Enum>(String key, List<TEnum> value) async {
    if (!_checkPrefs()) return;
    _prefs?.setInt(key, EnumConverter.enumListToFlag(value));
  }

  static Future<void> setStringList(String key, List<String> value) async {
    if (!_checkPrefs()) return;
    _prefs?.setStringList(key, value);
  }

  static List<String> getStringList(String key, {List<String> defaultValue = const []}) {
    if (!_checkPrefs()) return defaultValue;
    return _prefs?.getStringList(key) ?? defaultValue;
  }

  static Future<void> remove(String key) async {
    if (!_checkPrefs()) return;
    await _prefs?.remove(key);
  }

  static void debugLogAllKeys() {
    if (!_checkPrefs()) return;
    for (String key in _prefs!.getKeys()) {
      _logger.info('key: $key, value: ${_prefs!.get(key)}');
    }
  }

  static T? get<T>(String key, {T? defaultValue, T Function(Map<String, dynamic>)? factory}) {
    _checkPrefs();
    T? value;

    if (T is String) {
      value = getString(key) as T?;
    } else if (T is int) {
      value = getInt(key) as T?;
    } else if (T is double) {
      value = getDouble(key) as T?;
    } else if (T is bool) {
      value = getBool(key) as T?;
    } else if (T is DateTime) {
      value = getDateTime(key) as T?;
    } else if (T is List<String>) {
      value = getStringList(key) as T?;
    } else if (T is List<int>) {
      value = getIntList(key) as T?;
    } else if (T is List<double>) {
      value = getStringList(key).map((String value) => double.parse(value)).toList() as T?;
    } else if (T is List<bool>) {
      value = getStringList(key).map((String value) => value == 'true').toList() as T?;
    } else if (factory != null) {
      final jsonString = _prefs?.getString(key);
      if (jsonString != null) {
        value = json.decode(jsonString);
        return factory(value as Map<String, dynamic>);
      }
    }

    return value ?? defaultValue;
  }

  static Future<void> set<T>(String key, T value) async {
    _checkPrefs();

    if (T == String) {
      await setString(key, value as String);
    } else if (T == int) {
      await setInt(key, value as int);
    } else if (T == double) {
      await setDouble(key, value as double);
    } else if (T == bool) {
      await setBool(key, value as bool);
    } else if (T == DateTime) {
      await setDateTime(key, value as DateTime);
    } else if (T == List<String>) {
      await setStringList(key, value as List<String>);
    } else if (T == List<int>) {
      await setIntList(key, value as List<int>);
    } else if (T == List<double>) {
      await setStringList(key, (value as List<double>).map((double value) => value.toString()).toList());
    } else if (T == List<bool>) {
      await setStringList(key, (value as List<bool>).map((bool value) => value.toString()).toList());
    } else {
      await setString(key, json.encode(value));
    }
  }

  static bool hasKey(String key) {
    _checkPrefs();
    return _prefs!.containsKey(key);
  }
}
