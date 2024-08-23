import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsMap<TKey, TValue> {
  static final Map<String, PrefsMap> _cache = {};
  final String _prefsKey;
  final Logger _logger = Logger('PrefsMap<$TKey, $TValue>');
  late Map<TKey, TValue> _value;
  SharedPreferences? _prefs;

  PrefsMap._(this._prefsKey);

  static Future<PrefsMap<TKey, TValue>> create<TKey, TValue>(String key) async {
    if (!_cache.containsKey(key)) {
      var prefs = PrefsMap<TKey, TValue>._(key);
      await prefs._init();
      _cache[key] = prefs;
    }
    return _cache[key] as PrefsMap<TKey, TValue>;
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _load();
  }

  Map<TKey, TValue> get value {
    return _value;
  }

  set value(Map<TKey, TValue> newValue) {
    _value = newValue;
    _save();
  }

  void _load() {
    if (_prefs == null) return;

    var jsonString = _prefs!.getString(_prefsKey);
    if (jsonString != null) {
      try {
        var decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        _value =
            decoded.map((key, value) => MapEntry(key as TKey, value as TValue));
      } catch (e) {
        _logger.severe('Error decoding JSON: $e');
      }
    } else {
      _value = {};
    }
  }

  void _save() {
    if (_prefs == null) return;

    var jsonString = jsonEncode(_value);
    _prefs!.setString(_prefsKey, jsonString);
  }

  void put(TKey key, TValue value) {
    _value[key] = value;
    _save();
  }

  void remove(TKey key) {
    _value.remove(key);
    _save();
  }

  Future<void> clear() async {
    if (_prefs == null) return;
    await _prefs!.remove(_prefsKey);
    _value = {};
  }
}
