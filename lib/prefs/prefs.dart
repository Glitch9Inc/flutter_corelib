import 'dart:async';

import '../system/diagnostics/debug_log.dart';
import 'flutter_prefs.dart';

/// Cached preference value.
///
/// Prefer [setValue] when the caller needs write completion or failure.
class Prefs<T> {
  static final Map<String, Prefs<dynamic>> _cache = <String, Prefs<dynamic>>{};

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
    PrefsCacheRegistry.register<Prefs<T>>(key);
    final cached = _cache[key];
    if (cached != null) return cached as Prefs<T>;

    final prefs = Prefs<T>._internal(key, defaultValue, factory);
    prefs._initialize(overrideValue);
    _cache[key] = prefs;
    return prefs;
  }

  static void clearCache() => _cache.clear();

  T get value => _value ?? _defaultValue;

  set value(T? newValue) {
    unawaited(setValue(newValue));
  }

  Future<void> setValue(T? newValue) async {
    if (_value == newValue) return;
    _value = newValue;
    if (newValue == null) {
      await FlutterPrefs.remove(_prefsKey);
    } else {
      await FlutterPrefs.set<T>(_prefsKey, newValue);
    }
  }

  Future<void> clear() async {
    await FlutterPrefs.remove(_prefsKey);
    _value = null;
  }

  void _initialize(T? overrideValue) {
    if (overrideValue != null) {
      _value = overrideValue;
      unawaited(FlutterPrefs.set<T>(_prefsKey, overrideValue));
      return;
    }

    try {
      _value = FlutterPrefs.get<T>(
        _prefsKey,
        defaultValue: _defaultValue,
        factory: _factory,
      );
    } on Object catch (error, stackTrace) {
      Debug.warning('Failed to load $_prefsKey: $error');
      Debug.fine(stackTrace.toString());
      _value = _defaultValue;
    }
  }
}
