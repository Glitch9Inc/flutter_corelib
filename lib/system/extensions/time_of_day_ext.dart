import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

extension TimeOfDayExt on TimeOfDay {
  String stringify({bool use24HourFormat = true, bool hidePeriod = false}) {
    if (use24HourFormat) {
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } else {
      final hourText = hourOfPeriod.toString().padLeft(1, '0');
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
    if (includePeriod) {
      return '${hour.toString().padLeft(1, '0')}:${minute.toString().padLeft(2, '0')} ${period == DayPeriod.am ? 'AM' : 'PM'}';
    } else {
      return '${hour.toString().padLeft(1, '0')}:${minute.toString().padLeft(2, '0')}';
    }
  }

  String toSimpleString({bool includePeriod = true}) {
    if (includePeriod) {
      if (minute == 0) {
        return '${hour.toString().padLeft(1, '0')} ${period == DayPeriod.am ? 'AM' : 'PM'}';
      } else {
        return '${hour.toString().padLeft(1, '0')}:${minute.toString().padLeft(2, '0')} ${period == DayPeriod.am ? 'AM' : 'PM'}';
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
    final newHour = (totalMinutes ~/ 60) % 24;
    final newMinute = totalMinutes % 60;
    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  TimeOfDay subtract(Duration duration) {
    final totalMinutes = hour * 60 + minute - duration.inMinutes;
    // totalMinutes가 음수가 될 수 있으니 처리 필요
    final correctedTotalMinutes = (totalMinutes % (24 * 60) + (24 * 60)) % (24 * 60);
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
  TimeOfDay toTimeOfDay() {
    try {
      final parts = split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } catch (e) {
      Debug.severe(e);
      return const TimeOfDay(hour: 0, minute: 0);
    }
  }
}
