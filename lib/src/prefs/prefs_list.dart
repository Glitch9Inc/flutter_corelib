import 'dart:convert';

import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsList<T> {
  static final Map<String, PrefsList> _cache = {};
  final String _prefsKey;
  late List<T> _value;
  SharedPreferences? _prefs;

  PrefsList._(this._prefsKey);

  static Future<PrefsList<T>> create<T>(String key) async {
    if (!_cache.containsKey(key)) {
      var prefs = PrefsList<T>._(key);
      await prefs._init();
      _cache[key] = prefs;
    }
    return _cache[key] as PrefsList<T>;
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _load();
  }

  List<T> get value {
    return _value;
  }

  set value(List<T> newValue) {
    _value = newValue;
    _save();
  }

  void _load() {
    if (_prefs == null) return;

    var jsonString = _prefs!.getString(_prefsKey);
    if (jsonString != null) {
      try {
        var decoded = jsonDecode(jsonString) as List<dynamic>;
        _value = decoded.map((e) => e as T).toList();
      } catch (e) {
        Debug.logError('Error decoding JSON: $e');
      }
    } else {
      _value = [];
    }
  }

  void _save() {
    if (_prefs == null) return;

    var jsonString = jsonEncode(_value);
    _prefs!.setString(_prefsKey, jsonString);
  }

  void add(T item) {
    _value.add(item);
    _save();
  }

  void remove(T item) {
    _value.remove(item);
    _save();
  }

  Future<void> clear() async {
    if (_prefs == null) return;
    await _prefs!.remove(_prefsKey);
    _value = [];
  }
}
