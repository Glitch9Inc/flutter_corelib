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

  DateTime get nextWeek {
    return DateTime(year, month, day + 7);
  }

  DateTime get nextMonth {
    int nextMonth = month + 1;
    if (nextMonth > 12) nextMonth = 1;
    return DateTime(year, nextMonth, day);
  }

  DateTime get nextYear {
    return DateTime(year + 1, month, day);
  }

  static DateTime get startOfToday {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String toTimeString() {
    bool isAm = hour < 12;

    int hourParam = hour;
    if (hour > 12) {
      hourParam = hour - 12;
    } else if (hour == 0) {
      hourParam = 12;
    }
    return '${hourParam.toString()}:${minute.toString().padLeft(2, '0')} ${isAm ? 'AM' : 'PM'}';
  }

  String toLocalizedString() {
    return DateFormat.yMMMMd().format(this);
  }

  String toLocalizedMonthString() {
    return DateFormat.yMMMM().format(this);
  }

  String toAbbrString() {
    return DateFormat.MMMd().format(this);
  }

  int daysInMonth() {
    // 다음 달의 첫 번째 날
    var nextMonthFirstDay = (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);

    // 현재 달의 마지막 날
    var lastDay = nextMonthFirstDay.subtract(const Duration(days: 1)).day;

    return lastDay;
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
