import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

abstract class FirestoreConverter {
  static dynamic processDynamic(dynamic value) {
    if (value is DateTime) {
      return Timestamp.fromDate(value);
    } else if (value is Date) {
      return Timestamp.fromDate(value.toDateTime());
    } else {
      return value;
    }
  }
}
