import 'package:flutter/material.dart';
import '../diagnostics/debug_log.dart';

extension TimeOfDayExt on TimeOfDay {
  String stringify({bool use24HourFormat = true, bool hidePeriod = false}) {
    if (use24HourFormat) {
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } else {
      final hourText = (hourOfPeriod == 0 ? 12 : hourOfPeriod).toString();
      final minuteText = minute.toString().padLeft(2, '0');

      if (hidePeriod) {
        return '$hourText:$minuteText';
      } else {
        return '$hourText:$minuteText ${period == DayPeriod.am ? 'AM' : 'PM'}';
      }
    }
  }

  String toIso8601String() {
    return toDateTime().toIso8601String();
  }

  int differenceInMinutes(TimeOfDay other) {
    return (other.hour - hour) * 60 + (other.minute - minute);
  }

  String toDisplayString({bool includePeriod = true}) {
    final displayHour = hourOfPeriod == 0 ? 12 : hourOfPeriod;
    if (includePeriod) {
      return '$displayHour:${minute.toString().padLeft(2, '0')} '
          '${period == DayPeriod.am ? 'AM' : 'PM'}';
    } else {
      return '${hour.toString().padLeft(2, '0')}:'
          '${minute.toString().padLeft(2, '0')}';
    }
  }

  String toSimpleString({bool includePeriod = true}) {
    final displayHour = hourOfPeriod == 0 ? 12 : hourOfPeriod;
    if (includePeriod) {
      if (minute == 0) {
        return '$displayHour ${period == DayPeriod.am ? 'AM' : 'PM'}';
      } else {
        return '$displayHour:${minute.toString().padLeft(2, '0')} '
            '${period == DayPeriod.am ? 'AM' : 'PM'}';
      }
    } else {
      if (minute == 0) {
        return hour.toString().padLeft(1, '0');
      } else {
        return '${hour.toString().padLeft(1, '0')}:${minute.toString().padLeft(2, '0')}';
      }
    }
  }

  TimeOfDay add(Duration duration) {
    final totalMinutes = hour * 60 + minute + duration.inMinutes;
    final normalized = (totalMinutes % (24 * 60) + (24 * 60)) % (24 * 60);
    return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
  }

  TimeOfDay subtract(Duration duration) {
    final totalMinutes = hour * 60 + minute - duration.inMinutes;
    // totalMinutes가 음수가 될 수 있으니 처리 필요
    final correctedTotalMinutes =
        (totalMinutes % (24 * 60) + (24 * 60)) % (24 * 60);
    final newHour = correctedTotalMinutes ~/ 60;
    final newMinute = correctedTotalMinutes % 60;
    return TimeOfDay(hour: newHour, minute: newMinute);
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

  bool get isBeforeNow {
    final now = TimeOfDay.now();
    return isBefore(now);
  }

  bool get isAfterNow {
    final now = TimeOfDay.now();
    return isAfter(now);
  }

  DateTime toDateTime() {
    return DateTime(0, 1, 1, hour, minute);
  }

  Duration difference(TimeOfDay other) {
    final thisTime = toDateTime();
    final otherTime = other.toDateTime();
    return thisTime.difference(otherTime);
  }
}

extension TimeOfDayStringExt on String {
  TimeOfDay? tryToTimeOfDay() {
    final match = RegExp(r'^([01]?\d|2[0-3]):([0-5]\d)$').firstMatch(trim());
    if (match == null) return null;
    return TimeOfDay(
      hour: int.parse(match.group(1)!),
      minute: int.parse(match.group(2)!),
    );
  }

  TimeOfDay parseTimeOfDay() {
    final value = tryToTimeOfDay();
    if (value == null) {
      throw FormatException('Expected a 24-hour HH:mm value, got "$this".');
    }
    return value;
  }

  TimeOfDay toTimeOfDay() {
    try {
      return parseTimeOfDay();
    } on FormatException catch (error) {
      Debug.warning(error.message);
      return const TimeOfDay(hour: 0, minute: 0);
    }
  }
}
