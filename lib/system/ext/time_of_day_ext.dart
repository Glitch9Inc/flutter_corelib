import 'package:flutter/material.dart';

extension TimeOfDayExt on TimeOfDay {
  String toNetworkString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

extension TimeOfDayStringExt on String {
  TimeOfDay toTimeOfDay() {
    final parts = split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
