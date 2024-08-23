import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String format(String format, {bool returnDashIfNow = false}) {
    if (returnDashIfNow && isNow) return '-';
    return DateFormat(format).format(this);
  }

  bool get isToday {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  bool get isNow {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day && now.hour == hour && now.minute == minute;
  }

  DateTime get startOfWeek {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day - now.weekday + 1);
  }

  DateTime get endOfWeek {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + (7 - now.weekday));
  }
}

extension NullableDateTimeExt on DateTime? {
  String toFormattedString(String format, {bool returnDashIfNow = false}) {
    if (this == null || (returnDashIfNow && isNow)) return '-';
    return DateFormat(format).format(this!);
  }

  bool get isToday {
    if (this == null) return false;
    final now = DateTime.now();
    return now.year == this!.year && now.month == this!.month && now.day == this!.day;
  }

  bool get isNow {
    if (this == null) return false;
    final now = DateTime.now();
    return now.year == this!.year &&
        now.month == this!.month &&
        now.day == this!.day &&
        now.hour == this!.hour &&
        now.minute == this!.minute;
  }

  DateTime get startOfWeek {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day - now.weekday + 1);
  }

  DateTime get endOfWeek {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + (7 - now.weekday));
  }
}
