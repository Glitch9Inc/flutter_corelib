import 'dart:convert';

import 'package:flutter_corelib/core/system/prefs/playerprefs.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsList<T> {
  static final Map<String, PrefsList> _cache = {};
  SharedPreferences get _prefs => PlayerPrefs.getPrefs();

  final String _prefsKey;
  final Logger _logger = Logger('PrefsList<$T>');
  final List<T>? _enumValues;
  late List<T> _value;

  PrefsList._(this._prefsKey, {List<T>? enumValues}) : _enumValues = enumValues;

  static PrefsList<T> create<T>(String key, {List<T>? enumValues}) {
    if (!_cache.containsKey(key)) {
      var prefs = PrefsList<T>._(key, enumValues: enumValues);
      _cache[key] = prefs; // Cache the instance immediately
      prefs._init(); // Then initialize it asynchronously
    }
    return _cache[key] as PrefsList<T>;
  }

  void _init() {
    _logger.info('Initializing PrefsList for key $_prefsKey');
    _load();
    _logger.info('PrefsList $_prefsKey initialized');
  }

  List<T> get value {
    return _value;
  }

  bool get isEnum => _enumValues != null;

  set value(List<T> newValue) {
    _value = newValue;
    _save();
  }

  bool get isEmpty => _value.isEmpty;
  bool get isNotEmpty => _value.isNotEmpty;

  void _load() {
    String? jsonString;
    try {
      jsonString = _prefs.getString(_prefsKey);
    } catch (e) {
      _logger.severe('Error loading PrefsList with key $_prefsKey: $e');
      _logger.severe('Clearing PrefsList $_prefsKey');
      _prefs.remove(_prefsKey);
      _value = [];
    }

    _logger.info('Loading PrefsList with key: $_prefsKey, jsonString: $jsonString');

    if (jsonString != null) {
      try {
        var decoded = jsonDecode(jsonString) as List<dynamic>;

        // Deserialize items based on the expected type `T`
        if (isEnum) {
          if (_enumValues!.isEmpty) {
            _logger.severe('Enum values not provided for PrefsList<$T>');
            _value = [];
            return;
          }

          _value = decoded
              .map((e) {
                // convert e to int
                String eString = e.toString();
                int eInt = int.parse(eString);

                if (eInt < _enumValues.length) {
                  return _enumValues[eInt];
                } else {
                  _logger.severe('Invalid enum index: $e for key $_prefsKey');
                  return null;
                }
              })
              .whereType<T>()
              .toList();
        } else if (T == int) {
          _value = decoded.map((e) => e as int).toList() as List<T>;
        } else if (T == String) {
          _value = decoded.map((e) => e as String).toList() as List<T>;
        } else {
          _logger.warning('Unsupported type for PrefsList<$T>');
          _value = [];
        }
      } catch (e) {
        _logger.severe('Error decoding JSON for key $_prefsKey: $e');
        _value = [];
      }
    } else {
      _value = [];
    }
  }

  void _save() {
    try {
      // Encode the list to a JSON string before saving
      List<dynamic> encoded;

      if (isEnum) {
        if (_enumValues!.isEmpty) {
          _logger.severe('Enum values not provided for PrefsList<$T>');
          return;
        }
        encoded = _value.map((e) => _enumValues.indexOf(e)).toList();
      } else {
        encoded = _value;
      }

      var jsonString = jsonEncode(encoded);
      _prefs.setString(_prefsKey, jsonString);
    } catch (e) {
      _logger.severe('Error encoding JSON: $e');
    }
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
    await _prefs.remove(_prefsKey);
    _value = [];
  }
}
