import 'dart:collection';

class DateTimeList<T> {
  final Map<DateTime, T> data = SplayTreeMap();

  void add(DateTime date, T value) {
    data[date] = value;
  }

  void addAll(Map<DateTime, T> data) {
    this.data.addAll(data);
  }

  void remove(DateTime date) {
    data.remove(date);
  }

  void clear() {
    data.clear();
  }

  T? operator [](DateTime date) {
    return data[date];
  }

  bool containsKey(DateTime date) {
    return data.containsKey(date);
  }

  bool containsDay(DateTime date) {
    return data.keys.any((element) => element.year == date.year && element.month == date.month && element.day == date.day);
  }

  bool containsMonth(DateTime date) {
    return data.keys.any((element) => element.year == date.year && element.month == date.month);
  }

  bool containsYear(DateTime date) {
    return data.keys.any((element) => element.year == date.year);
  }

  DateTime get dateFrom {
    if (data.isEmpty) {
      throw StateError("No data available");
    }
    return data.keys.reduce((value, element) => value.isBefore(element) ? value : element);
  }

  DateTime get dateTo {
    if (data.isEmpty) {
      throw StateError("No data available");
    }
    return data.keys.reduce((value, element) => value.isAfter(element) ? value : element);
  }

  List<T> getHourlyList(DateTime date) {
    return data.entries
        .where((element) =>
            element.key.year == date.year &&
            element.key.month == date.month &&
            element.key.day == date.day &&
            element.key.hour == date.hour)
        .map((e) => e.value)
        .toList();
  }

  List<T> getDailyList(DateTime date) {
    return data.entries
        .where((element) => element.key.year == date.year && element.key.month == date.month && element.key.day == date.day)
        .map((e) => e.value)
        .toList();
  }

  List<T> getListBetween(DateTime from, DateTime to) {
    return data.entries
        .where((element) =>
            !element.key.isBefore(from) && // from 포함
            !element.key.isAfter(to)) // to 포함
        .map((e) => e.value)
        .toList();
  }

  List<T> getMonthlyList(DateTime date) {
    return data.entries.where((element) => element.key.year == date.year && element.key.month == date.month).map((e) => e.value).toList();
  }

  List<T> getYearlyList(DateTime date) {
    return data.entries.where((element) => element.key.year == date.year).map((e) => e.value).toList();
  }

  /// Returns a map of hourly lists of the day.
  /// Key is the hour of the day. (0 ~ 23)
  Map<int, List<T>> getHourlyListMap(DateTime date) {
    return Map.fromEntries(List.generate(24, (hour) {
      final values = data.entries
          .where((element) =>
              element.key.year == date.year && element.key.month == date.month && element.key.day == date.day && element.key.hour == hour)
          .map((e) => e.value)
          .toList();
      return MapEntry(hour, values);
    }));
  }

  /// Returns a map of daily lists of the month.
  /// Key is the day of the month. (1 ~ 31)
  Map<int, List<T>> getDailyListMap(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0).day;
    return Map.fromEntries(List.generate(lastDay, (index) {
      final day = data.entries
          .where((element) =>
              element.key.year == date.year && element.key.month == date.month && element.key.day == index + 1) // index + 1로 날짜 보정
          .map((e) => e.value)
          .toList();
      return MapEntry(index + 1, day); // MapEntry 키도 1부터 시작
    }));
  }

  /// Returns a map of monthly lists of the year.
  /// Key is the month of the year. (1 ~ 12)
  Map<int, List<T>> getMonthlyListMap(DateTime date) {
    return Map.fromEntries(List.generate(12, (index) {
      final month = data.entries
          .where((element) => element.key.year == date.year && element.key.month == index + 1) // index + 1로 월 보정
          .map((e) => e.value)
          .toList();
      return MapEntry(index + 1, month); // MapEntry 키도 1부터 시작
    }));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DateTimeList<T> && other.data == data;
  }

  @override
  int get hashCode => data.hashCode ^ dateFrom.hashCode ^ dateTo.hashCode;
}
