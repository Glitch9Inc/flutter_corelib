import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreUtil {
  static Map<String, Timestamp> toTimestampMap(Map<String, DateTime>? timestamps) {
    if (timestamps == null) {
      return {};
    }
    return timestamps.map((key, value) => MapEntry(key, Timestamp.fromDate(value)));
  }

  static Map<String, DateTime> toDateTimeMap(Map<String, Object?>? timestamps) {
    if (timestamps == null) {
      return {};
    }
    return timestamps.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate());
      } else {
        return MapEntry(key, DateTime.now());
      }
    });
  }

  static dynamic processDynamic(dynamic value) {
    if (value is DateTime) {
      return Timestamp.fromDate(value);
    } else {
      return value;
    }
  }
}
