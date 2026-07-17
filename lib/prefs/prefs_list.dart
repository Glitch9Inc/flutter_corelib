import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';

import 'flutter_prefs.dart';

class PrefsList<T> {
  static final Map<String, PrefsList<dynamic>> _cache =
      <String, PrefsList<dynamic>>{};

  final String _prefsKey;
  final Logger _logger = Logger('PrefsList<$T>');
  final List<T>? _enumValues;
  List<T> _value = <T>[];

  PrefsList._(this._prefsKey, {List<T>? enumValues}) : _enumValues = enumValues;

  static PrefsList<T> create<T>(String key, {List<T>? enumValues}) {
    PrefsCacheRegistry.register<PrefsList<T>>(key);
    final cached = _cache[key];
    if (cached != null) return cached as PrefsList<T>;

    final prefs = PrefsList<T>._(key, enumValues: enumValues);
    prefs._load();
    _cache[key] = prefs;
    return prefs;
  }

  static void clearCache() => _cache.clear();

  List<T> get value => List<T>.unmodifiable(_value);

  set value(List<T> newValue) {
    unawaited(setValue(newValue));
  }

  bool get isEnum => _enumValues != null;
  bool get isEmpty => _value.isEmpty;
  bool get isNotEmpty => _value.isNotEmpty;

  Future<void> setValue(List<T> newValue) async {
    _value = List<T>.of(newValue);
    await _save();
  }

  Future<void> add(T item) async {
    _value.add(item);
    await _save();
  }

  Future<void> remove(T item) async {
    _value.remove(item);
    await _save();
  }

  Future<void> clear() async {
    await FlutterPrefs.remove(_prefsKey);
    _value = <T>[];
  }

  void _load() {
    final jsonString = FlutterPrefs.getStringOrNull(_prefsKey);
    if (jsonString == null) return;

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! List<dynamic>) {
        throw const FormatException('Expected a JSON list.');
      }

      if (isEnum) {
        final enumValues = _enumValues!;
        _value = decoded
            .map((item) => _decodeEnum(item, enumValues))
            .whereType<T>()
            .toList(growable: true);
      } else if (T == int) {
        _value = decoded.cast<int>().cast<T>().toList(growable: true);
      } else if (T == double) {
        _value = decoded
            .map((item) => (item as num).toDouble())
            .cast<T>()
            .toList(growable: true);
      } else if (T == bool) {
        _value = decoded.cast<bool>().cast<T>().toList(growable: true);
      } else if (T == String) {
        _value = decoded.cast<String>().cast<T>().toList(growable: true);
      } else {
        throw UnsupportedError('PrefsList<$T> requires a codec.');
      }
    } on Object catch (error, stackTrace) {
      _logger.warning(
        'Failed to decode preference "$_prefsKey".',
        error,
        stackTrace,
      );
      _value = <T>[];
    }
  }

  T? _decodeEnum(Object? stored, List<T> values) {
    if (stored is String) {
      for (final value in values) {
        if (value is Enum && value.name == stored) return value;
      }
      return null;
    }
    if (stored is int && stored >= 0 && stored < values.length) {
      return values[stored];
    }
    return null;
  }

  Future<void> _save() async {
    final encoded = isEnum
        ? _value.map((item) {
            if (item is! Enum) {
              throw StateError('Enum values expected for PrefsList<$T>.');
            }
            return item.name;
          }).toList(growable: false)
        : _value;
    await FlutterPrefs.setString(_prefsKey, jsonEncode(encoded));
  }
}
