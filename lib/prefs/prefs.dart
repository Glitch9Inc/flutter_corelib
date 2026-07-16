import 'package:flutter_corelib/system/utils/debug_log.dart';

import 'flutter_prefs.dart';

/// Make sure [FlutterPrefs] is initialized before using it.
class Prefs<T> {
  static final Map<String, Prefs> _cache = {};
  final String _prefsKey;
  final T _defaultValue;
  final T Function(Map<String, dynamic>)? _factory;
  T? _value;

  Prefs._internal(this._prefsKey, this._defaultValue, this._factory);

  static Prefs<T> create<T>(
    String key,
    T defaultValue, {
    T? overrideValue,
    T Function(Map<String, dynamic>)? factory,
  }) {
    if (!_cache.containsKey(key)) {
      var prefs = Prefs<T>._internal(key, defaultValue, factory);
      prefs._internalInit(overrideValue);
      _cache[key] = prefs;
    }
    return _cache[key] as Prefs<T>;
  }

  void _internalInit(T? overrideValue) {
    if (overrideValue != null) {
      _value = overrideValue;
      _save();
    } else {
      _load();
    }
  }

  T get value {
    _value ??= _defaultValue;
    return _value!;
  }

  set value(T? newValue) {
    setValue(newValue);
  }

  Future<void> setValue(T? newValue) async {
    if (_value == newValue) return;
    _value = newValue;
    await _save();
  }

  Future<void> _load() async {
    try {
      _value = FlutterPrefs.get<T>(
        _prefsKey,
        defaultValue: _defaultValue,
        factory: _factory,
      );
    } catch (e) {
      Debug.warning('Failed to load $_prefsKey, removing the value: $e');
      _value = null;
    }

    if (_value == null) {
      _value = _defaultValue;
      await _save();
    }
  }

  Future<void> _save() async {
    final value = _value;
    if (value == null) return;
    FlutterPrefs.set<T>(_prefsKey, value);
  }

  Future<void> clear() async {
    await FlutterPrefs.remove(_prefsKey);
    _value = null;
  }
}
