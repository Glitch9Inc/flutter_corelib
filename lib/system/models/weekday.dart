import 'package:flutter_corelib/system/models/string_format.dart';

abstract class Weekday {
  static const int sunday = 7;
  static const int monday = 1;
  static const int tuesday = 2;
  static const int wednesday = 3;
  static const int thursday = 4;
  static const int friday = 5;
  static const int saturday = 6;
  static const List<int> everyday = [1, 2, 3, 4, 5, 6, 7];
  static const List<int> weekdays = [1, 2, 3, 4, 5];
  static const List<int> weekends = [6, 7];

  static const _keys = {
    sunday: 'sun',
    monday: 'mon',
    tuesday: 'tue',
    wednesday: 'wed',
    thursday: 'thu',
    friday: 'fri',
    saturday: 'sat'
  };
  static int parse(String weekday) =>
      _keys.entries.firstWhere((element) => element.value == weekday).key;
  static String format(int weekday, [StringFormat format = StringFormat.key]) =>
      format.formatWeekday(weekday);

  static String formatList(List<int> weekdays,
      [StringFormat format = StringFormat.short]) {
    if (_listEquals(weekdays, everyday)) return 'Everyday';
    if (_listEquals(weekdays, Weekday.weekdays)) return 'Weekdays';
    if (_listEquals(weekdays, weekends)) return 'Weekends';
    return [
      if (weekdays.contains(7)) format.formatWeekday(Weekday.sunday),
      if (weekdays.contains(1)) format.formatWeekday(Weekday.monday),
      if (weekdays.contains(2)) format.formatWeekday(Weekday.tuesday),
      if (weekdays.contains(3)) format.formatWeekday(Weekday.wednesday),
      if (weekdays.contains(4)) format.formatWeekday(Weekday.thursday),
      if (weekdays.contains(5)) format.formatWeekday(Weekday.friday),
      if (weekdays.contains(6)) format.formatWeekday(Weekday.saturday),
    ].join(', ');
  }

  static bool _listEquals(List<int> first, List<int> second) {
    if (first.length != second.length) return false;
    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) return false;
    }
    return true;
  }
}
