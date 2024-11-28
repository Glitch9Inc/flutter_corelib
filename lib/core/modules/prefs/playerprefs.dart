import 'dart:convert';

import 'package:flutter_corelib/flutter_corelib.dart';

abstract class EnumConverter {
  static int enumToInt<TEnum extends Enum>(TEnum value) {
    return value.index;
  }

  static TEnum intToEnum<TEnum extends Enum>(int value, List<TEnum> values) {
    return values[value];
  }

  static int enumListToInt<TEnum extends Enum>(List<TEnum> values) {
    return values.map((TEnum value) => value.index).reduce((int a, int b) => a | b);
  }

  static List<TEnum> intToEnumList<TEnum extends Enum>(int value, List<TEnum> values) {
    final List<TEnum> result = [];
    for (int i = 0; i < values.length; i++) {
      if ((value & (1 << i)) != 0) {
        result.add(values[i]);
      }
    }
    return result;
  }
}

abstract class PlayerPrefs {
  static SharedPreferences? _prefs;
  static bool _isInit = false;
  static final Logger _logger = Logger('PlayerPrefs');

  static Future<void> init() async {
    if (_isInit) return;
    _isInit = true;
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences getPrefs() {
    if (!_isInit || _prefs == null) {
      _logger.severe('PlayerPrefs is not initialized');
    }

    return _prefs!;
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

  static DateTime? getDateTime(String key, {DateTime? defaultValue}) {
    _checkPrefs();
    final int? value = _prefs?.getInt(key);
    if (value == null) return defaultValue;
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  static void setDateTime(String key, DateTime value) async {
    _checkPrefs();
    _prefs?.setInt(key, value.millisecondsSinceEpoch);
  }

  static void setInt(String key, int value) async {
    _checkPrefs();
    _prefs?.setInt(key, value);
  }

  static int getInt(String key, {int defaultValue = 0}) {
    _checkPrefs();
    return _prefs?.getInt(key) ?? defaultValue;
  }

  static void setIntList(String key, List<int> value) async {
    _checkPrefs();
    _prefs?.setStringList(key, value.map((int value) => value.toString()).toList());
  }

  static List<int> getIntList(String key, {List<int> defaultValue = const []}) {
    _checkPrefs();
    var stringList = _prefs?.getStringList(key);
    if (stringList == null) {
      return defaultValue;
    }
    return stringList.map((String value) => int.parse(value)).toList();
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

  static TEnum getEnum<TEnum extends Enum>(String key, List<TEnum> values, {TEnum? defaultValue}) {
    _checkPrefs();
    final int value = _prefs?.getInt(key) ?? -1;
    if (value == -1) {
      return defaultValue!;
    }
    return EnumConverter.intToEnum(value, values);
  }

  static void setEnum<TEnum extends Enum>(String key, TEnum value) async {
    _checkPrefs();
    _prefs?.setInt(key, EnumConverter.enumToInt(value));
  }

  static List<TEnum> getEnumList<TEnum extends Enum>(String key, List<TEnum> values, {List<TEnum> defaultValue = const []}) {
    _checkPrefs();
    return EnumConverter.intToEnumList(_prefs?.getInt(key) ?? 0, values);
  }

  static void setEnumList<TEnum extends Enum>(String key, List<TEnum> value) async {
    _checkPrefs();
    _prefs?.setInt(key, EnumConverter.enumListToInt(value));
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

  static T? get<T>(String key, {T? defaultValue}) {
    _checkPrefs();
    T? value;

    if (T == String) {
      value = _prefs?.getString(key) as T?;
    } else if (T == int) {
      value = _prefs?.getInt(key) as T?;
    } else if (T == double) {
      value = _prefs?.getDouble(key) as T?;
    } else if (T == bool) {
      value = _prefs?.getBool(key) as T?;
    } else if (T == List<String>) {
      value = _prefs?.getStringList(key) as T?;
    } else if (T == List<int>) {
      value = getIntList(key) as T?;
    } else if (T == List<double>) {
      value = _prefs?.getStringList(key)?.map((String value) => double.parse(value)).toList() as T?;
    } else if (T == List<bool>) {
      value = _prefs?.getStringList(key)?.map((String value) => value == 'true').toList() as T?;
    } else {
      final jsonString = _prefs?.getString(key);
      if (jsonString != null) {
        value = json.decode(jsonString) as T?;
      }
    }

    return value ?? defaultValue;
  }

  static void set<T>(String key, T value) {
    _checkPrefs();

    if (T == String) {
      _prefs?.setString(key, value as String);
    } else if (T == int) {
      _prefs?.setInt(key, value as int);
    } else if (T == double) {
      _prefs?.setDouble(key, value as double);
    } else if (T == bool) {
      _prefs?.setBool(key, value as bool);
    } else if (T == List<String>) {
      _prefs?.setStringList(key, value as List<String>);
    } else if (T == List<int>) {
      setIntList(key, value as List<int>);
    } else if (T == List<double>) {
      _prefs?.setStringList(key, (value as List<double>).map((double value) => value.toString()).toList());
    } else if (T == List<bool>) {
      _prefs?.setStringList(key, (value as List<bool>).map((bool value) => value.toString()).toList());
    } else {
      _prefs?.setString(key, json.encode(value));
    }
  }

  static bool hasKey(String key) {
    _checkPrefs();
    return _prefs!.containsKey(key);
  }
}
