import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String toFormattedString(String format, {bool returnDashIfNow = false}) {
    if (returnDashIfNow && isNow) return '-';
    return DateFormat(format).format(this);
  }

  bool get isToday {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  bool get isNow {
    final now = DateTime.now();
    return now.year == year &&
        now.month == month &&
        now.day == day &&
        now.hour == hour &&
        now.minute == minute;
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
