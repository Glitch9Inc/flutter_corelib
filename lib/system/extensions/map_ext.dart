import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

extension MapExt on Map<String, dynamic> {
  static final Logger _logger = Logger('MapExt');

  bool _isNullOrEmpty<T>(T? value) {
    if (value == null) return true;
    if (value is String) {
      if (value.isEmpty) return true;
      if (value.toLowerCase() == 'null') return true;
      if (value.startsWith('*')) return true; // 데이터가 없지만 설명을 위해 간혹 셀안에 *과 텍스트를 넣는 경우가 있음
    }
    if (value is Iterable) {
      if (value.isEmpty) return true; // 빈 List 또는 Set 체크
    }
    if (value is Map) {
      if (value.isEmpty) return true; // 빈 Map 체크
    }
    return false;
  }

  Map<String, dynamic> removeNullEntries() {
    final json = Map<String, dynamic>.from(this);
    final keys = json.keys.toList();

    for (final key in keys) {
      if (json[key] == null) json.remove(key);
    }

    return json;
  }

  String getId() => getString('id');

  String getString(String key, {String defaultValue = ''}) {
    return getStringOrNull(key) ?? defaultValue;
  }

  String? getStringOrNull(String key) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return null;
    if (value is String) return value;
    return value.toString();
  }

  int getInt(String key, {int defaultValue = 0}) {
    return getIntOrNull(key) ?? defaultValue;
  }

  int? getIntOrNull(String key) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return null;
    if (value is num) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }

    return null;
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    return getDoubleOrNull(key) ?? defaultValue;
  }

  double? getDoubleOrNull(String key) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return null;
    if (value is num) return value.toDouble();
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value);

    return null;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return getBoolOrNull(key) ?? defaultValue;
  }

  bool? getBoolOrNull(String key) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return null;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase().trim() == 'true' || value == '1';
    if (value is int) return value == 1;

    return null;
  }

  List<T> getList<T>(
    String key, {
    List<T>? defaultValue,
    T Function(Object)? mapper,
    T Function(Map<String, dynamic>)? factory,
  }) {
    defaultValue ??= []; // 기본값 초기화
    return getListOrNull(key, mapper: mapper, factory: factory) ?? defaultValue;
  }

  List<T>? getListOrNull<T>(
    String key, {
    T Function(Object)? mapper,
    T Function(Map<String, dynamic>)? factory,
  }) {
    final value = this[key];

    // Null 또는 빈 값 체크
    if (_isNullOrEmpty(value)) {
      //_logger.shout("Key: $key is null or empty. Returning default value.");
      return null;
    }

    // List<T> 타입인지 확인
    if (value is List<T>) {
      return value;
    }

    try {
      if (value is List) {
        if (mapper != null) {
          // 사용자 정의 매퍼
          return value.map((e) => mapper(e)).toList();
        } else if (factory != null) {
          // Factory 메서드
          return value.map((e) => factory(e as Map<String, dynamic>)).toList();
        } else if (T == int) {
          return value.map((e) => e as int).toList().cast<T>();
        } else if (T == double) {
          return value.map((e) => e as double).toList().cast<T>();
        } else if (T == String) {
          return value.map((e) => e.toString()).toList().cast<T>();
        } else if (T == bool) {
          return value.map((e) => e as bool).toList().cast<T>();
        }
      }
    } catch (e) {
      _logger.severe('Error in getList: $e');
      _logger.severe('getList type: $T, received value type: ${value.runtimeType}');
    }

    _logger.shout("Key: $key does not contain a valid list. Returning default value.");
    return null;
  }

  List<String> getStringList(String key, {List<String>? defaultValue}) {
    return getStringListOrNull(key) ?? defaultValue ?? [];
  }

  List<String>? getStringListOrNull(String key) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return null;
    if (value is List<String>) return value;
    if (value is List<dynamic>) return value.map((e) => e.toString()).toList();

    return null;
  }

  /// the input type must be [String]
  List<String> getStringListCsv(String key) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return [];
    if (value is! String) return [];

    List<String> list = value.split(',');
    return list.map((e) => e.toSnakeCase()).toList();
  }

  /// the input type must be [String]
  List<T> getEnumListCsv<T extends Enum>(String key, List<T> values) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return [];
    if (value is! String) return [];
    if (value == 'all') return values;

    List<String> list = value.split(',').map((e) => e.trim()).toList();

    List<T> result = [];
    for (String element in list) {
      if (element.isEmpty) continue;
      try {
        T matchedEnum = values.firstWhere(
          (e) => e.name.toLowerCase() == element.toLowerCase(),
        );
        result.add(matchedEnum);
      } catch (e) {
        _logger.warning('Enum not found: $element');
      }
    }

    // enum의 인덱스 순서대로 정렬
    return result..sort((a, b) => a.index.compareTo(b.index));
  }

  Map<TKey, TValue> getMap<TKey, TValue>(
    String key, {
    TKey Function(Object)? keyMapper,
    TValue Function(Object)? valueMapper,
    TValue Function(Map<String, dynamic>)? factory,
    Map<TKey, TValue>? defaultValue,
  }) {
    final value = this[key];
    if (_isNullOrEmpty(value)) return defaultValue ?? {};

    // 기본 타입 처리
    if (isBaseType<TKey>() && isBaseType<TValue>()) {
      // value는 dynamic이다.
      if (value is Map<TKey, TValue>) return value;
      if (value is Map<String, dynamic>) {
        return value.map((key, value) {
          return MapEntry(key as TKey, value as TValue);
        });
      }
    }

    // 커스텀 파싱 로직
    if (value is Map) {
      return value.map<TKey, TValue>((rawKey, rawValue) {
        // 키 처리
        final processedKey = keyMapper?.call(rawKey) ?? rawKey as TKey;

        // 값 처리
        final processedValue = valueMapper?.call(rawValue) ?? factory?.call(rawValue as Map<String, dynamic>) ?? rawValue as TValue;

        return MapEntry(processedKey, processedValue);
      });
    }

    _logger.warning('값이 Map 타입이 아닙니다: $key, $TKey, $TValue');
    return defaultValue ?? {};
  }

  Map<String, dynamic> getJson(String key, {Map<String, dynamic>? defaultValue}) {
    return getJsonOrNull(key) ?? defaultValue ?? {};
  }

  Map<String, dynamic>? getJsonOrNull(String key) {
    final value = this[key];
    if (_isNullOrEmpty(value)) return null;
    if (value is Map<String, dynamic>) return value;
    return value as Map<String, dynamic>?;
  }

  Map<String, int> getIntMap(String key, {Map<String, int>? defaultValue}) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return defaultValue ?? {};
    if (value is Map<String, dynamic>) {
      return value.map((key, value) => MapEntry(key, value as int));
    }

    return defaultValue ?? {};
  }

  Map<String, String> getStringMap(String key, {Map<String, String>? defaultValue}) {
    try {
      var map = this[key] as Map<String, dynamic>?;
      return map?.map((key, value) => MapEntry(key, value as String)) ?? defaultValue ?? {};
    } catch (e) {
      _logger.severe('Error in getStringMap: $e');
      return defaultValue ?? {};
    }
  }

  Map<String, bool> getBoolMap(String key, {Map<String, bool>? defaultValue}) {
    try {
      var map = this[key] as Map<String, dynamic>?;
      return map?.map((key, value) => MapEntry(key, value as bool)) ?? defaultValue ?? {};
    } catch (e) {
      _logger.severe('Error in getBoolMap: $e');
      return defaultValue ?? {};
    }
  }

  Map<String, DateTime> getDateTimeMap(String key, {Map<String, DateTime>? defaultValue}) {
    try {
      final value = this[key];

      if (_isNullOrEmpty(value)) return defaultValue ?? {};
      if (value is Map<String, DateTime>) return value;
      if (value is Map<String, Timestamp>) return value.map((key, value) => MapEntry(key, convertToDateTime(value, DateTime.now())));

      return defaultValue ?? {};
    } catch (e) {
      _logger.severe('Error in getDateTimeMap: $e');
      return defaultValue ?? {};
    }
  }

  T getEnum<T extends Enum>(String key, List<T> values, {T? defaultValue}) {
    return getEnumOrNull(key, values) ?? defaultValue ?? values.first;
  }

  T? getEnumOrNull<T extends Enum>(String key, List<T> values) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return null;

    if (value is T) return value;

    switch (value.runtimeType) {
      case String:
        return values.firstWhereOrNull((element) => _parseEnumName(element.toString()) == _parseEnumName(value.toString()));
      case int:
        return values.firstWhereOrNull((element) => element.index == value);
    }

    return null;
  }

  List<T> getEnumList<T extends Enum>(String key, List<T> values, {List<T>? defaultValue}) {
    final value = this[key];
    defaultValue ??= [];

    if (_isNullOrEmpty(value)) return defaultValue;
    if (value is List<T>) return value;

    if (value is String) {
      if (value.isEmpty) return defaultValue;
      if (value.toLowerCase() == 'all') return values;
      return value.split(',').map((e) {
        return values.firstWhere((element) => _parseEnumName(element.toString()) == _parseEnumName(e.toString()), orElse: () {
          _logger.warning('Enum not found with name: $e');
          return values.first;
        });
      }).toList();
    }

    if (value is List<String>) {
      return value
          .where((e) => e.isNotEmpty) // Skip empty strings
          .map((e) => values.firstWhere((element) => _parseEnumName(element.toString()).toLowerCase() == _parseEnumName(e.toString()).toLowerCase()))
          .toList();
    }

    if (value is List<dynamic>) {
      return value
          .where((e) => e == null || (e is String && e.isNotEmpty)) // Skip empty strings
          .map((e) => values.firstWhere((element) => _parseEnumName(element.toString()).toLowerCase() == _parseEnumName(e.toString()).toLowerCase()))
          .toList();
    }

    return defaultValue;
  }

  TimeOfDay getTimeOfDay(String key, {TimeOfDay? defaultValue}) {
    return getTimeOfDayOrNull(key) ?? defaultValue ?? TimeOfDay.now();
  }

  TimeOfDay? getTimeOfDayOrNull(String key) {
    String? stringValue = this[key] as String?;
    if (stringValue == null) return null;
    return stringValue.toTimeOfDay();
  }

  DateTime getDateTime(String key, {DateTime? defaultValue}) {
    return getDateTimeOrNull(key) ?? defaultValue ?? DateTime.now();
  }

  DateTime? getDateTimeOrNull(String key) {
    var value = this[key];

    if (_isNullOrEmpty(value)) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return (this[key] as Timestamp).toDate();
    if (value is String) return DateTime.tryParse(this[key] as String);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);

    return null;
  }

  T? getObject<T>(String key, T Function(Object) mapper, {T? defaultValue}) {
    final value = this[key];
    if (_isNullOrEmpty(value)) return defaultValue;
    return mapper(value) ?? defaultValue;
  }

  Timestamp getTimestamp(String key, {Timestamp? defaultValue}) {
    return getTimestampOrNull(key) ?? defaultValue ?? Timestamp.now();
  }

  Timestamp? getTimestampOrNull(String key) {
    final value = this[key];
    if (_isNullOrEmpty(value)) return null;
    if (value is Timestamp) return value;
    return null;
  }

  // Utility functions
  String _parseEnumName(String enumAsString) => enumAsString.split('.').last.toLowerCase();

  /// Get a [Duration] value from the map.
  /// If the value is an integer, it is treated as minutes.
  Duration getDuration(String key, {Duration defaultValue = Duration.zero}) {
    return getDurationOrNull(key) ?? defaultValue;
  }

  Duration? getDurationOrNull(String key) {
    final value = this[key];
    if (_isNullOrEmpty(value)) return null;

    if (value is int) return Duration(minutes: value);
    if (value is String) return Duration(minutes: int.tryParse(value) ?? 0);

    return null;
  }

  T getCast<T>(
    String key, {
    T Function(Object)? mapper,
    T Function(Map<String, dynamic>)? factory,
    T Function(String)? stringFactory,
    required T defaultValue,
  }) {
    final value = this[key];
    if (_isNullOrEmpty(value)) return defaultValue;
    if (stringFactory != null && value is String) return stringFactory(value);
    if (mapper != null) return mapper(value);
    if (factory != null) return factory(value as Map<String, dynamic>);
    return value as T;
  }

  T? getCastOrNull<T>(
    String key, {
    T Function(Object)? mapper,
    T Function(Map<String, dynamic>)? factory,
    T Function(String)? stringFactory,
  }) {
    final value = this[key];
    if (_isNullOrEmpty(value)) return null;
    if (stringFactory != null && value is String) return stringFactory(value);
    if (mapper != null) return mapper(value);
    if (factory != null) return factory(value as Map<String, dynamic>);
    return value as T;
  }

  bool isBaseType<T>() {
    return T == String || T == int || T == double || T == bool;
  }

  DateTime convertToDateTime(dynamic value, DateTime defaultValue) {
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    _logger.warning('Failed to convert value to DateTime: $value');
    return defaultValue;
  }

  // Map<int /* weekday */, TimeOfDay>

  Map<int, TimeOfDay> getTimeOfDayMap(String key, {Map<int, TimeOfDay>? defaultValue}) {
    final value = this[key];
    if (_isNullOrEmpty(value)) return defaultValue ?? {};

    if (value is Map<int, TimeOfDay>) return value;
    if (value is Map<String, String>) return value.map((key, value) => MapEntry(Weekday.parse(key), value.toTimeOfDay()));

    return defaultValue ?? {};
  }

  TimeOfDayRange getTimeOfDayRange(String key, {TimeOfDayRange? defaultValue}) {
    defaultValue ??= TimeOfDayRange.empty;
    return getTimeOfDayRangeOrNull(key) ?? defaultValue;
  }

  TimeOfDayRange? getTimeOfDayRangeOrNull(String key) {
    final value = this[key];
    if (_isNullOrEmpty(value)) return null;

    if (value is TimeOfDayRange) return value;

    try {
      return TimeOfDayRange.fromJson(value as Map<String, dynamic>);
    } catch (e) {
      _logger.severe('Error in getTimeRange: $e');
      return null;
    }
  }

  TimeRange getTimeRange(String key, {TimeRange? defaultValue}) {
    defaultValue ??= TimeRange.empty;
    return getTimeRangeOrNull(key) ?? defaultValue;
  }

  TimeRange? getTimeRangeOrNull(String key) {
    final value = this[key];
    if (_isNullOrEmpty(value)) return null;

    if (value is TimeRange) return value;

    try {
      return TimeRange.fromJson(value as Map<String, dynamic>);
    } catch (e) {
      _logger.severe('Error in getTimeRange: $e');
      return null;
    }
  }
}
