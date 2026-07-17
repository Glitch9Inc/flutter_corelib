abstract class DateTimeBuilder {
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime startOfThisWeek() {
    final now = DateTime.now();
    final weekday = now.weekday;
    return DateTime(now.year, now.month, now.day - weekday + 1);
  }

  static DateTime startOfWeek(DateTime date) {
    return DateTime(date.year, date.month, date.day - date.weekday + 1);
  }

  static DateTime yesterday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 1));
  }

  static DateTime tomorrow() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
  }

  static List<DateTime> datesThisWeek() {
    // return dates from Monday to Sunday
    List<DateTime> dates = [];
    DateTime today = DateTimeBuilder.today();
    DateTime thisMonday = today.subtract(Duration(days: today.weekday - 1));
    for (int i = 0; i < 7; i++) {
      dates.add(thisMonday.add(Duration(days: i)));
    }

    return dates;
  }
}

abstract class DateTimeKey {
  static String format(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  static DateTime parse(String dateKey) {
    final parts = dateKey.split('-');
    return DateTime(
        int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }
}
