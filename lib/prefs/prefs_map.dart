import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';

import 'flutter_prefs.dart';

class PrefsMap<TKey, TValue> {
  static final Map<String, PrefsMap<dynamic, dynamic>> _cache =
      <String, PrefsMap<dynamic, dynamic>>{};

  final String _prefsKey;
  final Logger _logger = Logger('PrefsMap<$TKey, $TValue>');
  Map<TKey, TValue> _value = <TKey, TValue>{};

  PrefsMap._(this._prefsKey);

  static Future<PrefsMap<TKey, TValue>> create<TKey, TValue>(String key) async {
    if (TKey != String) {
      throw UnsupportedError(
        'PrefsMap JSON keys must be String; requested $TKey.',
      );
    }
    PrefsCacheRegistry.register<PrefsMap<TKey, TValue>>(key);
    final cached = _cache[key];
    if (cached != null) return cached as PrefsMap<TKey, TValue>;

    final prefs = PrefsMap<TKey, TValue>._(key).._load();
    _cache[key] = prefs;
    return prefs;
  }

  static void clearCache() => _cache.clear();

  Map<TKey, TValue> get value => Map<TKey, TValue>.unmodifiable(_value);

  set value(Map<TKey, TValue> newValue) {
    unawaited(setValue(newValue));
  }

  Future<void> setValue(Map<TKey, TValue> newValue) async {
    _value = Map<TKey, TValue>.of(newValue);
    await _save();
  }

  Future<void> put(TKey key, TValue value) async {
    _value[key] = value;
    await _save();
  }

  Future<void> remove(TKey key) async {
    _value.remove(key);
    await _save();
  }

  Future<void> clear() async {
    await FlutterPrefs.remove(_prefsKey);
    _value = <TKey, TValue>{};
  }

  void _load() {
    final jsonString = FlutterPrefs.getStringOrNull(_prefsKey);
    if (jsonString == null) return;

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object.');
      }
      _value = decoded.map<TKey, TValue>(
        (key, value) => MapEntry(key as TKey, value as TValue),
      );
    } on Object catch (error, stackTrace) {
      _logger.warning(
        'Failed to decode preference "$_prefsKey".',
        error,
        stackTrace,
      );
      _value = <TKey, TValue>{};
    }
  }

  Future<void> _save() {
    return FlutterPrefs.setString(_prefsKey, jsonEncode(_value));
  }
}
