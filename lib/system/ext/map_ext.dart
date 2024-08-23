import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

extension IntMapExt on Map<String, int>? {
  Map<String, int> increaseInt(String key, int intToAdd) {
    if (this == null) return {key: intToAdd};
    int current = this![key] ?? 0;
    Map<String, int> value = this ?? {};
    value[key] = current + intToAdd;
    return value;
  }

  int getSum() {
    if (this == null) return 0;
    return this!.values.fold(0, (a, b) => a + b);
  }

  int getInt(String key) {
    if (this == null) return 0;
    return this![key] ?? 0;
  }
}

extension DateTimeMapExt on Map<String, DateTime>? {
  DateTime getDateTime(String key) {
    if (this == null) return DateTime.now();
    return this![key] ?? DateTime.now();
  }

  DateTime? getNullableDateTime(String key) {
    if (this == null) return null;
    return this![key];
  }
}

extension DynamicMapExt on Map<String, dynamic> {
  String getString(String key, {String? defaultValue}) {
    return this[key] as String? ?? defaultValue ?? '';
  }

  int getInt(String key, {int defaultValue = 0}) {
    if (this[key] is String) {
      return int.tryParse(this[key] as String) ?? defaultValue;
    }
    return this[key] as int? ?? defaultValue;
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    final value = this[key];
    if (value is num) {
      return value.toDouble();
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is double) {
      return value;
    }
    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }

    return defaultValue;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    if (this[key] is String) {
      return (this[key] as String).toLowerCase() == 'true';
    }
    return this[key] as bool? ?? defaultValue;
  }

  List<T> getList<T>(String key, {T Function(Object)? mapper}) {
    final value = this[key];
    if (value is List<T>) {
      return value;
    }
    if (value is List<dynamic> && mapper != null) {
      return value.map((e) => mapper(e)).toList();
    }
    if (value is List<Object>? && value != null && mapper != null) {
      return value.map((e) => mapper(e)).toList();
    }
    return [];
  }

  List<String> getStringList(String key) {
    final value = this[key];
    if (value is List<String>) {
      return value;
    }
    if (value is List<dynamic>) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  List<String> getCsvList(String key) {
    String csv = this[key] as String? ?? '';
    List<String> list = csv.split(',');
    return list.map((e) => e.toSnakeCase()).toList();
  }

  List<T> getCsvEnumList<T extends Enum>(String key, List<T> values) {
    String csv = this[key] as String? ?? '';
    if (csv == 'all') return values;

    List<String> list = csv.split(',').map((e) => e.trim()).toList();

    List<T> result = [];
    for (String element in list) {
      try {
        T matchedEnum = values.firstWhere(
          (e) => e.name.toLowerCase() == element.toLowerCase(),
        );
        result.add(matchedEnum);
      } catch (e) {
        print('Enum not found: $element');
      }
    }
    return result;
  }

  Map<String, T> getCastMap<T>(String key, T Function(Object) mapper) {
    var map = this[key] as Map<String, dynamic>? ?? {};
    return map.map((key, value) => MapEntry(key, mapper(value)));
  }

  Map<String, Object> getMap(String key) {
    if (this[key] is Map<String, Object>) {
      return this[key] as Map<String, Object>;
    }
    if (this[key] is Map<String, dynamic>) {
      return (this[key] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as Object));
    }
    return {};
  }

  Map<String, int> getIntMap(String key) {
    var map = this[key] as Map<String, dynamic>?;
    return map?.map((key, value) => MapEntry(key, value as int)) ?? {};
  }

  Map<String, String> getStringMap(String key) {
    var map = this[key] as Map<String, dynamic>?;
    return map?.map((key, value) => MapEntry(key, value as String)) ?? {};
  }

  Map<String, DateTime> getDateTimeMap(String key) {
    final value = this[key];
    if (value is Map<String, DateTime>) {
      return value;
    }

    if (value is Map<String, Timestamp>) {
      return value.map((key, value) => MapEntry(key, value.toDate()));
    }

    if (value is Map<String, dynamic>) {
      return value.map((key, value) {
        if (value is Timestamp) {
          return MapEntry(key, value.toDate());
        }
        if (value is String) {
          return MapEntry(key, DateTime.tryParse(value) ?? DateTime.now());
        }
        return MapEntry(key, value as DateTime);
      });
    }

    return {};
  }

  String _getEnumName(String enumAsString) {
    return enumAsString.split('.').last;
  }

  T getEnum<T extends Enum>(String key, List<T> values, {T? defaultValue}) {
    for (T value in values) {
      if (_getEnumName(value.toString()).toLowerCase() == _getEnumName(this[key].toString().toLowerCase())) {
        return value;
      }
    }
    print('Enum not found: ${this[key]}');
    return defaultValue ?? values.first;
  }

  List<T> getEnumList<T extends Enum>(String key, List<T> values) {
    final value = this[key];

    if (value is List<T>) {
      return value;
    }

    if (value is List<String>) {
      return value
          .map((e) => values.firstWhere(
              (element) => _getEnumName(element.toString()).toLowerCase() == _getEnumName(e.toString()).toLowerCase()))
          .toList();
    }

    if (value is List<dynamic>) {
      return value
          .map((e) => values.firstWhere(
              (element) => _getEnumName(element.toString()).toLowerCase() == _getEnumName(e.toString()).toLowerCase()))
          .toList();
    }

    return [];
  }

  TimeOfDay getTimeOfDay(String key, {TimeOfDay? defaultValue}) {
    String? stringValue = this[key] as String?;
    if (stringValue == null) return defaultValue ?? TimeOfDay.now();
    return stringValue.toTimeOfDay();
  }

  DateTime getDateTime(String key, {DateTime? defaultValue}) {
    var value = this[key];

    if (value is DateTime) {
      return value;
    }

    if (value is Timestamp) {
      return (this[key] as Timestamp).toDate();
    }

    if (value is String) {
      return DateTime.tryParse(this[key] as String) ?? defaultValue ?? DateTime.now();
    }

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    return defaultValue ?? DateTime.now();
  }

  Date getDate(String key, {Date? defaultValue}) {
    if (this[key] is Timestamp) {
      return Date.fromDateTime((this[key] as Timestamp).toDate());
    }
    return this[key] as Date? ?? defaultValue ?? Date.today();
  }

  T? getObject<T>(String key, {T? defaultValue}) {
    if (this[key] is T) {
      return this[key] as T;
    }
    return defaultValue;
  }

  Timestamp getTimestamp(String key, {Timestamp? defaultValue}) {
    if (this[key] is Timestamp) {
      return this[key] as Timestamp;
    }
    return defaultValue ?? Timestamp.now();
  }
}
