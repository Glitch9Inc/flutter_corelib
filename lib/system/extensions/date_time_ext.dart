import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String format(String format, {bool returnDashIfNow = false}) {
    if (returnDashIfNow && isNow) return '-';
    return DateFormat(format).format(this);
  }

  String toKey() {
    return DateFormat('yyyyMMdd').format(this);
  }

  bool isAfterOrEqual(DateTime other) {
    return isAfter(other) || isAtSameMomentAs(other);
  }

  bool isBeforeOrEqual(DateTime other) {
    return isBefore(other) || isAtSameMomentAs(other);
  }

  bool isSameHour(DateTime other) {
    return year == other.year && month == other.month && day == other.day && hour == other.hour;
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameWeek(DateTime other) {
    return year == other.year && weekOfYear == other.weekOfYear;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  bool isSameYear(DateTime other) {
    return year == other.year;
  }

  bool get isToday {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.year == year && tomorrow.month == month && tomorrow.day == day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.year == year && yesterday.month == month && yesterday.day == day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    return now.year == year && now.weekOfYear == weekOfYear;
  }

  bool get isNextWeek {
    final now = DateTime.now();
    return now.year == year && now.weekOfYear == weekOfYear + 1;
  }

  bool get isLastWeek {
    final now = DateTime.now();
    return now.year == year && now.weekOfYear == weekOfYear - 1;
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return now.year == year && now.month == month;
  }

  bool get isNextMonth {
    final now = DateTime.now();
    return now.year == year && now.month == month + 1;
  }

  bool get isLastMonth {
    final now = DateTime.now();
    return now.year == year && now.month == month - 1;
  }

  bool get isThisYear {
    final now = DateTime.now();
    return now.year == year;
  }

  bool get isNextYear {
    final now = DateTime.now();
    return now.year == year + 1;
  }

  bool get isLastYear {
    final now = DateTime.now();
    return now.year == year - 1;
  }

  int get weekOfYear {
    final firstDayOfYear = DateTime(year, 1, 1);
    final firstDayOfYearWeekday = firstDayOfYear.weekday;
    final firstDayOfYearWeek = firstDayOfYearWeekday == 1 ? 1 : 1 + (7 - firstDayOfYearWeekday + 1);
    final daysSinceFirstDayOfYear = difference(firstDayOfYear).inDays;
    return (daysSinceFirstDayOfYear - firstDayOfYearWeek) ~/ 7 + 1;
  }

  bool get isNow {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day && now.hour == hour && now.minute == minute;
  }

  bool get isPast {
    return isBefore(DateTime.now());
  }

  DateTime getStartOfWeek(int startingWeekday) {
    if (startingWeekday < 1 || startingWeekday > 7) {
      throw ArgumentError('Starting weekday must be between 1 and 7');
    }

    final now = DateTime.now();
    int daysUntilStartOfWeek = (startingWeekday - now.weekday) % 7;

    // 현재 주로 보정: 음수라면 7을 더함
    if (daysUntilStartOfWeek > 0) {
      daysUntilStartOfWeek -= 7;
    }

    return DateTime(now.year, now.month, now.day + daysUntilStartOfWeek);
  }

  DateTime getEndOfWeek(int startingWeekday) {
    if (startingWeekday < 1 || startingWeekday > 7) {
      throw ArgumentError('Starting weekday must be between 1 and 7');
    }

    final now = DateTime.now();
    final daysUntilEndOfWeek = (7 - now.weekday + startingWeekday) % 7;
    return DateTime(now.year, now.month, now.day + daysUntilEndOfWeek);
  }

  DateTime get nextWeek {
    return DateTime(year, month, day + 7);
  }

  DateTime get nextMonth {
    int nextMonth = month + 1;
    if (nextMonth > 12) {
      return DateTime(year + 1, 1, day);
    }
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

  String toLocalizedMonthAbbr() {
    return DateFormat.MMM().format(this);
  }

  String toAbbrString() {
    return DateFormat.MMMd().format(this);
  }

  int get daysInMonth {
    // 다음 달의 첫 번째 날
    var nextMonthFirstDay = (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);

    // 현재 달의 마지막 날
    var lastDay = nextMonthFirstDay.subtract(const Duration(days: 1)).day;

    return lastDay;
  }

  List<DateTime> get lastSevenDays {
    List<DateTime> days = [];

    for (int i = 0; i < 7; i++) {
      days.add(subtract(Duration(days: i)));
    }

    return days;
  }

  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  DateTime get firstDayOfPrevMonth {
    if (month == 1) {
      return DateTime(year - 1, 12, 1);
    } else {
      return DateTime(year, month - 1, 1);
    }
  }

  DateTime get firstDayOfNextMonth {
    if (month == 12) {
      return DateTime(year + 1, 1, 1);
    } else {
      return DateTime(year, month + 1, 1);
    }
  }
}

extension NullableDateTimeExt on DateTime? {
  String toFormattedString(String format, {bool returnDashIfNow = false, bool daySuffix = false}) {
    if (this == null || (returnDashIfNow && isNow)) return '-';

    final date = this!;
    final formattedDate = DateFormat(format).format(date);

    if (daySuffix) {
      // `dd`에 해당하는 날짜를 찾아서 서수 추가
      final day = date.day;
      final suffix = _getDaySuffix(day);

      // `dd`를 날짜 + 서수로 교체
      return formattedDate.replaceFirst(
        RegExp(r'\b\d{1,2}\b'), // 숫자 형식
        '$day$suffix',
      );
    }

    return formattedDate;
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th'; // 11th, 12th, 13th 예외 처리
    }
    switch (day % 10) {
      case 1:
        return 'st'; // 1st
      case 2:
        return 'nd'; // 2nd
      case 3:
        return 'rd'; // 3rd
      default:
        return 'th'; // 4th, 5th, 6th, ...
    }
  }

  bool get isToday {
    if (this == null) return false;
    final now = DateTime.now();
    return now.year == this!.year && now.month == this!.month && now.day == this!.day;
  }

  bool get isNow {
    if (this == null) return false;
    final now = DateTime.now();
    return now.year == this!.year && now.month == this!.month && now.day == this!.day && now.hour == this!.hour && now.minute == this!.minute;
  }
}
