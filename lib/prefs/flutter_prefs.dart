import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../system/converters/enum_converter.dart';

/// Typed facade for [SharedPreferences].
///
/// Call [ensureInitialized] once during application bootstrap. All concurrent
/// callers share the same initialization future and all writes complete only
/// after the underlying store reports completion.
abstract class FlutterPrefs {
  static SharedPreferences? _prefs;
  static Future<void>? _initialization;
  static final Logger _logger = Logger('FlutterPrefs');

  static bool get isInitialized => _prefs != null;

  static Future<void> ensureInitialized() {
    if (_prefs != null) return Future<void>.value();
    return _initialization ??= _initialize();
  }

  static Future<void> _initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (_) {
      _initialization = null;
      rethrow;
    }
  }

  /// Replaces the backing store for an isolated test.
  static void setPreferencesForTesting(SharedPreferences preferences) {
    _prefs = preferences;
    _initialization = Future<void>.value();
    PrefsCacheRegistry.clear();
  }

  /// Clears static state between tests.
  static void resetForTesting() {
    _prefs = null;
    _initialization = null;
    PrefsCacheRegistry.clear();
  }

  static SharedPreferences getPrefs() {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError(
        'FlutterPrefs is not initialized. '
        'Await FlutterPrefs.ensureInitialized() during bootstrap.',
      );
    }
    return prefs;
  }

  static Future<void> setString(String key, String value) async {
    await _requireWrite(await getPrefs().setString(key, value), key);
  }

  static String getString(String key, {String defaultValue = ''}) {
    return getStringOrNull(key) ?? defaultValue;
  }

  static String? getStringOrNull(String key) => getPrefs().getString(key);

  static DateTime? getDateTime(String key, {DateTime? defaultValue}) {
    final value = getPrefs().getInt(key);
    if (value == null) return defaultValue;
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  static Future<void> setDateTime(String key, DateTime value) async {
    await _requireWrite(
      await getPrefs().setInt(key, value.millisecondsSinceEpoch),
      key,
    );
  }

  static Future<void> setInt(String key, int value) async {
    await _requireWrite(await getPrefs().setInt(key, value), key);
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return getIntOrNull(key) ?? defaultValue;
  }

  static int? getIntOrNull(String key) => getPrefs().getInt(key);

  static Future<void> setIntList(String key, List<int> value) {
    return setStringList(
      key,
      value.map((item) => item.toString()).toList(growable: false),
    );
  }

  static List<int> getIntList(
    String key, {
    List<int> defaultValue = const <int>[],
  }) {
    final values = getPrefs().getStringList(key);
    if (values == null) return defaultValue;
    return values.map(int.parse).toList(growable: false);
  }

  static Future<void> setDouble(String key, double value) async {
    await _requireWrite(await getPrefs().setDouble(key, value), key);
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    return getDoubleOrNull(key) ?? defaultValue;
  }

  static double? getDoubleOrNull(String key) => getPrefs().getDouble(key);

  static Future<void> setBool(String key, bool value) async {
    await _requireWrite(await getPrefs().setBool(key, value), key);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return getBoolOrNull(key) ?? defaultValue;
  }

  static bool? getBoolOrNull(String key) => getPrefs().getBool(key);

  static TEnum getEnum<TEnum extends Enum>(
    String key,
    List<TEnum> values, {
    TEnum? defaultValue,
  }) {
    final value = getEnumOrNull(key, values);
    if (value != null) return value;
    if (defaultValue != null) return defaultValue;
    throw StateError('No enum value stored for "$key" and no default given.');
  }

  static TEnum? getEnumOrNull<TEnum extends Enum>(
    String key,
    List<TEnum> values,
  ) {
    final stored = getPrefs().get(key);
    if (stored == null) return null;
    if (stored is String) {
      return EnumConverter.nameToEnum(stored, values);
    }
    if (stored is int) {
      return EnumConverter.indexToEnumOrNull(stored, values);
    }
    throw FormatException(
      'Expected enum name or legacy index for "$key", got ${stored.runtimeType}.',
    );
  }

  static Future<void> setEnum<TEnum extends Enum>(
    String key,
    TEnum value,
  ) {
    return setString(key, value.name);
  }

  static List<TEnum> getEnumList<TEnum extends Enum>(
    String key,
    List<TEnum> values, {
    List<TEnum> defaultValue = const <Never>[],
  }) {
    final stored = getPrefs().get(key);
    if (stored == null) return defaultValue;
    if (stored is List<String>) {
      return stored
          .map((name) => EnumConverter.nameToEnumOrNull(name, values))
          .whereType<TEnum>()
          .toList(growable: false);
    }
    if (stored is int) {
      return EnumConverter.flagToEnumList(stored, values);
    }
    throw FormatException(
      'Expected enum names or legacy bit flag for "$key", '
      'got ${stored.runtimeType}.',
    );
  }

  static Future<void> setEnumList<TEnum extends Enum>(
    String key,
    List<TEnum> value,
  ) {
    return setStringList(
      key,
      value.map((item) => item.name).toList(growable: false),
    );
  }

  static Future<void> setStringList(String key, List<String> value) async {
    await _requireWrite(await getPrefs().setStringList(key, value), key);
  }

  static List<String> getStringList(
    String key, {
    List<String> defaultValue = const <String>[],
  }) {
    return getPrefs().getStringList(key) ?? defaultValue;
  }

  static Future<void> remove(String key) async {
    await _requireWrite(await getPrefs().remove(key), key);
  }

  static void debugLogAllKeys() {
    for (final key in getPrefs().getKeys()) {
      _logger.info('SharedPreferences key: $key');
    }
  }

  static T? get<T>(
    String key, {
    T? defaultValue,
    T Function(Map<String, dynamic>)? factory,
  }) {
    final prefs = getPrefs();
    Object? value;

    if (T == String) {
      value = prefs.getString(key);
    } else if (T == int) {
      value = prefs.getInt(key);
    } else if (T == double) {
      value = prefs.getDouble(key);
    } else if (T == bool) {
      value = prefs.getBool(key);
    } else if (T == DateTime) {
      value = getDateTime(key);
    } else if (T == List<String>) {
      value = prefs.getStringList(key);
    } else if (T == List<int>) {
      value = prefs.getStringList(key)?.map(int.parse).toList(growable: false);
    } else if (T == List<double>) {
      value =
          prefs.getStringList(key)?.map(double.parse).toList(growable: false);
    } else if (T == List<bool>) {
      value = prefs.getStringList(key)?.map(_parseBool).toList(growable: false);
    } else {
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final decoded = jsonDecode(jsonString);
        if (factory != null) {
          if (decoded is! Map<String, dynamic>) {
            throw FormatException(
              'Expected a JSON object for "$key", got ${decoded.runtimeType}.',
            );
          }
          value = factory(decoded);
        } else {
          value = decoded;
        }
      }
    }

    if (value == null) return defaultValue;
    if (value is! T) {
      throw FormatException(
        'Stored value for "$key" is ${value.runtimeType}, expected $T.',
      );
    }
    return value as T;
  }

  static Future<void> set<T>(String key, T value) async {
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
      await setStringList(
        key,
        (value as List<double>)
            .map((item) => item.toString())
            .toList(growable: false),
      );
    } else if (T == List<bool>) {
      await setStringList(
        key,
        (value as List<bool>)
            .map((item) => item.toString())
            .toList(growable: false),
      );
    } else {
      await setString(key, jsonEncode(value));
    }
  }

  static bool hasKey(String key) => getPrefs().containsKey(key);

  static Future<void> _requireWrite(bool succeeded, String key) async {
    if (!succeeded) {
      throw StateError('SharedPreferences rejected write for "$key".');
    }
  }

  static bool _parseBool(String value) {
    if (value == 'true') return true;
    if (value == 'false') return false;
    throw FormatException('Expected "true" or "false", got "$value".');
  }
}

/// Shared cache registry used to reject duplicate keys with different types.
abstract class PrefsCacheRegistry {
  static final Map<String, Type> _types = <String, Type>{};

  static void register<T>(String key) {
    final existing = _types[key];
    if (existing != null && existing != T) {
      throw StateError(
        'Preference key "$key" is already registered as $existing, not $T.',
      );
    }
    _types[key] = T;
  }

  static void clear() => _types.clear();
}
