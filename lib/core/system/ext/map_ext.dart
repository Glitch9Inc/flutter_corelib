import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

extension DynamicMapExt on Map<String, dynamic> {
  bool _isNullOrEmpty<T>(T? value) {
    if (value == null) return true;
    if (value is String) {
      if (value.isEmpty) return true;
      if (value.toLowerCase() == 'null') return true;
      if (value.startsWith('*')) return true; // 데이터가 없지만 설명을 위해 간혹 셀안에 *과 텍스트를 넣는 경우가 있음
    }
    return false;
  }

  String getId() {
    return getString('id');
  }

  String getUuid() {
    var uuid = getNullableString('uuid');
    if (uuid == null) return getId();
    return uuid;
  }

  String getString(String key, {String? defaultValue}) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return defaultValue ?? '';
    if (value is String) return value;
    return value.toString();
  }

  String? getNullableString(String key) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return null;
    if (value is String) return value;
    return value.toString();
  }

  int getInt(String key, {int defaultValue = 0}) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return defaultValue;
    if (value is num) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }

    // 로그를 남기거나 처리할 수 없는 타입에 대해 에러를 던질 수 있습니다.
    print('Warning: Unexpected type for key $key: ${value.runtimeType}');
    return defaultValue;
  }

  int? getNullableInt(String key) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return null;
    if (value is num) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }

    // 로그를 남기거나 처리할 수 없는 타입에 대해 에러를 던질 수 있습니다.
    print('Warning: Unexpected type for key $key: ${value.runtimeType}');
    return null;
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return defaultValue;
    if (value is num) return value.toDouble();
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? defaultValue;

    return defaultValue;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return defaultValue;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase().trim() == 'true' || value == '1';
    if (value is int) return value == 1;

    return defaultValue;
  }

  List<T> getList<T>(String key, {List<T> defaultValue = const [], T Function(Object)? mapper}) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return defaultValue;
    if (value is List<T>) return value;

    if (value is List<dynamic> && mapper != null) {
      return value.map((e) => mapper(e)).toList();
    }

    if (value is List<Object>? && value != null && mapper != null) {
      return value.map((e) => mapper(e)).toList();
    }

    return defaultValue;
  }

  List<String> getStringList(String key, {List<String>? defaultValue}) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return defaultValue ?? [];
    if (value is List<String>) return value;
    if (value is List<dynamic>) return List<String>.from(value);

    return defaultValue ?? [];
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
        print('Enum not found: $element');
      }
    }

    // enum의 인덱스 순서대로 정렬
    return result..sort((a, b) => a.index.compareTo(b.index));
  }

  Map<String, T> getCastMap<T>(String key, T Function(Object) mapper, {Map<String, T>? defaultValue}) {
    var map = this[key] as Map<String, dynamic>? ?? defaultValue;
    return map?.map((key, value) => MapEntry(key, mapper(value))) ?? defaultValue ?? {};
  }

  Map<String, dynamic> getMap(String key, {Map<String, dynamic>? defaultValue}) {
    final value = this[key];
    if (_isNullOrEmpty(value)) return defaultValue ?? {};
    if (value is Map<String, dynamic>) return value;
    return defaultValue ?? {};
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
      print('Error in getStringMap: $e');
      return defaultValue ?? {};
    }
  }

  Map<String, DateTime> getDateTimeMap(String key, {Map<String, DateTime>? defaultValue}) {
    try {
      final value = this[key];

      if (_isNullOrEmpty(value)) return defaultValue ?? {};
      if (value is Map<String, DateTime>) return value;
      if (value is Map<String, Timestamp>) return value.map((key, value) => MapEntry(key, value.toDate()));
      if (value is Map<String, dynamic>) {
        return value.map((key, value) {
          if (value is Timestamp) return MapEntry(key, value.toDate());
          if (value is String) return MapEntry(key, DateTime.tryParse(value) ?? DateTime.now());
          return MapEntry(key, value as DateTime);
        });
      }

      return defaultValue ?? {};
    } catch (e) {
      print('Error in getDateTimeMap: $e');
      return defaultValue ?? {};
    }
  }

  T getEnum<T extends Enum>(String key, List<T> values, {T? defaultValue}) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return defaultValue ?? values.first;
    if (value is T) return value;
    if (value is String) {
      if (value.isEmpty) return defaultValue ?? values.first;
      return values.firstWhere((element) => _getEnumName(element.toString()) == _getEnumName(value.toString()), orElse: () {
        print('Enum not found with name: $value');
        return defaultValue ?? values.first;
      });
    }
    if (value is int) {
      return values.firstWhere((element) => element.index == value, orElse: () {
        print('Enum not found with index: $value');
        return defaultValue ?? values.first;
      });
    }

    return defaultValue ?? values.first;
  }

  List<T> getEnumList<T extends Enum>(String key, List<T> values) {
    final value = this[key];

    if (_isNullOrEmpty(value)) return [];
    if (value is List<T>) return value;

    if (value is String) {
      if (value.isEmpty) return [];
      if (value.toLowerCase() == 'all') return values;
      return value.split(',').map((e) {
        return values.firstWhere((element) => _getEnumName(element.toString()) == _getEnumName(e.toString()), orElse: () {
          print('Enum not found with name: $e');
          return values.first;
        });
      }).toList();
    }

    if (value is List<String>) {
      return value
          .where((e) => e.isNotEmpty) // Skip empty strings
          .map((e) =>
              values.firstWhere((element) => _getEnumName(element.toString()).toLowerCase() == _getEnumName(e.toString()).toLowerCase()))
          .toList();
    }

    if (value is List<dynamic>) {
      return value
          .where((e) => e == null || (e is String && e.isNotEmpty)) // Skip empty strings
          .map((e) =>
              values.firstWhere((element) => _getEnumName(element.toString()).toLowerCase() == _getEnumName(e.toString()).toLowerCase()))
          .toList();
    }

    return [];
  }

  TimeOfDay? getTimeOfDay(String key, {TimeOfDay? defaultValue}) {
    String? stringValue = this[key] as String?;
    if (stringValue == null) return defaultValue;
    return stringValue.toTimeOfDay();
  }

  DateTime getDateTime(String key, {DateTime? defaultValue}) {
    var value = this[key];
    defaultValue ??= DateTime.now();

    if (_isNullOrEmpty(value)) return defaultValue;
    if (value is DateTime) return value;
    if (value is Timestamp) return (this[key] as Timestamp).toDate();
    if (value is String) return DateTime.tryParse(this[key] as String) ?? defaultValue;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);

    return defaultValue;
  }

  Date getDate(String key, {Date? defaultValue}) {
    if (this[key] is Timestamp) {
      return Date.fromDateTime((this[key] as Timestamp).toDate());
    }
    return this[key] as Date? ?? defaultValue ?? Date.today();
  }

  T? get<T>(String key, T Function(Object) mapper, {T? defaultValue}) {
    final value = this[key];
    if (_isNullOrEmpty(value)) return defaultValue;
    return mapper(value) ?? defaultValue;
  }

  Timestamp getTimestamp(String key, {Timestamp? defaultValue}) {
    final value = this[key];
    if (_isNullOrEmpty(value)) return defaultValue ?? Timestamp.now();

    if (value is Timestamp) return value;
    return defaultValue ?? Timestamp.now();
  }

  // Utility functions
  String _getEnumName(String enumAsString) => enumAsString.split('.').last.toLowerCase();

  // Added on 2024-09-01

  /// Get a [Duration] value from the map.
  /// If the value is an integer, it is treated as minutes.
  Duration? getDuration(String key, {Duration? defaultValue}) {
    final value = this[key];
    if (_isNullOrEmpty(value)) return defaultValue;

    if (value is int) return Duration(minutes: value);
    if (value is String) return Duration(minutes: int.tryParse(value) ?? 0);

    return defaultValue;
  }
}
