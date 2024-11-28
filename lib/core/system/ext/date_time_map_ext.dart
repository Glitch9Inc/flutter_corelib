import 'package:cloud_firestore/cloud_firestore.dart';

extension DateTimeMapExt on Map<String, DateTime>? {
  DateTime getDateTimeOrNowIfNull(String key) {
    if (this == null) return DateTime.now();
    return this![key] ?? DateTime.now();
  }

  Map<String, Timestamp>? toTimestampMap() {
    if (this == null) return null;
    return this!.map((key, value) => MapEntry(key, Timestamp.fromDate(value)));
  }
}
