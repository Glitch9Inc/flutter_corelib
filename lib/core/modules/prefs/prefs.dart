import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs<T> {
  static final Map<String, Prefs> _cache = {};
  final String _prefsKey;
  final Logger _logger = Logger('Prefs<$T>');
  T? _value;
  SharedPreferences? _prefs;

  Prefs._(this._prefsKey);

  static Future<Prefs<T>> create<T>(String key) async {
    if (!_cache.containsKey(key)) {
      var prefs = Prefs<T>._(key);
      await prefs._init();
      _cache[key] = prefs;
    }
    return _cache[key] as Prefs<T>;
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _load();
  }

  T? get value {
    return _value;
  }

  set value(T? newValue) {
    if (_value == newValue) return;
    _value = newValue;
    _save();
  }

  void _load() {
    if (_prefs == null) return;

    if (T == String) {
      _value = _prefs!.getString(_prefsKey) as T?;
    } else if (T == int) {
      _value = _prefs!.getInt(_prefsKey) as T?;
    } else if (T == double) {
      _value = _prefs!.getDouble(_prefsKey) as T?;
    } else if (T == bool) {
      _value = _prefs!.getBool(_prefsKey) as T?;
    } else if (T == List<String>) {
      _value = _prefs!.getStringList(_prefsKey) as T?;
    } else {
      var jsonString = _prefs!.getString(_prefsKey);
      if (jsonString != null) {
        try {
          _value = jsonDecode(jsonString) as T;
        } catch (e) {
          _logger.severe('Error decoding JSON: $e');
        }
      }
    }
  }

  void _save() {
    if (_prefs == null || _value == null) return;

    if (_value is String) {
      _prefs!.setString(_prefsKey, _value as String);
    } else if (_value is int) {
      _prefs!.setInt(_prefsKey, _value as int);
    } else if (_value is double) {
      _prefs!.setDouble(_prefsKey, _value as double);
    } else if (_value is bool) {
      _prefs!.setBool(_prefsKey, _value as bool);
    } else if (_value is List<String>) {
      _prefs!.setStringList(_prefsKey, _value as List<String>);
    } else {
      String jsonString = jsonEncode(_value);
      _prefs!.setString(_prefsKey, jsonString);
    }
  }

  Future<void> clear() async {
    if (_prefs == null) return;
    await _prefs!.remove(_prefsKey);
    _value = null;
  }
}
