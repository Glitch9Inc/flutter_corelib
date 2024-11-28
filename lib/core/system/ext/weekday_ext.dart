import 'package:flutter_corelib/flutter_corelib.dart';

extension WeekdayExt on Weekday {
  String get shortName {
    switch (this) {
      case Weekday.monday:
        return 'Mon';
      case Weekday.tuesday:
        return 'Tue';
      case Weekday.wednesday:
        return 'Wed';
      case Weekday.thursday:
        return 'Thu';
      case Weekday.friday:
        return 'Fri';
      case Weekday.saturday:
        return 'Sat';
      case Weekday.sunday:
        return 'Sun';
    }
  }

  String get letter {
    switch (this) {
      case Weekday.monday:
        return 'M';
      case Weekday.tuesday:
        return 'T';
      case Weekday.wednesday:
        return 'W';
      case Weekday.thursday:
        return 'T';
      case Weekday.friday:
        return 'F';
      case Weekday.saturday:
        return 'S';
      case Weekday.sunday:
        return 'S';
    }
  }
}
