import 'package:flutter/material.dart';

extension TimeOfDayExt on TimeOfDay {
  String toNetworkString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  int differenceInMinutes(TimeOfDay other) {
    return (other.hour - hour) * 60 + (other.minute - minute);
  }

  String toDisplayString({bool includePeriod = true}) {
    //return '${hour.toString()}:${minute.toString().padLeft(2, '0')} ${period == DayPeriod.am ? 'AM' : 'PM'}';
    if (includePeriod) {
      return '${hour.toString().padLeft(1, '0')}:${minute.toString().padLeft(2, '0')} ${period == DayPeriod.am ? 'AM' : 'PM'}';
    } else {
      return '${hour.toString().padLeft(1, '0')}:${minute.toString().padLeft(2, '0')}';
    }
  }

  (String hourMinute, String ampm) toDisplayStrings() {
    String hourMinute = '${hour.toString().padLeft(1, '0')}:${minute.toString().padLeft(2, '0')}';
    String ampm = period == DayPeriod.am ? 'AM' : 'PM';
    return (hourMinute, ampm);
  }

  TimeOfDay add(Duration duration) {
    final newMinute = minute + duration.inMinutes;
    final newHour = hour + newMinute ~/ 60;
    return TimeOfDay(hour: newHour % 24, minute: newMinute % 60);
  }

  TimeOfDay subtract(Duration duration) {
    final newMinute = minute - duration.inMinutes;
    final newHour = hour + newMinute ~/ 60;
    return TimeOfDay(hour: newHour % 24, minute: newMinute % 60);
  }

  int compareTo(TimeOfDay other) {
    if (hour < other.hour) {
      return -1;
    } else if (hour > other.hour) {
      return 1;
    } else {
      return minute.compareTo(other.minute);
    }
  }

  bool isAfter(TimeOfDay time) {
    if (hour > time.hour) {
      return true;
    } else if (hour == time.hour) {
      return minute > time.minute;
    } else {
      return false;
    }
  }

  bool isBefore(TimeOfDay time) {
    if (hour < time.hour) {
      return true;
    } else if (hour == time.hour) {
      return minute < time.minute;
    } else {
      return false;
    }
  }

  DateTime toDateTime() {
    return DateTime(0, 1, 1, hour, minute);
  }
}

extension TimeOfDayStringExt on String {
  TimeOfDay toTimeOfDay() {
    final parts = split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}
