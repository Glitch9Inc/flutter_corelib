enum Weekday {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
}

extension WeekdayExtension on Weekday {
  String get displayName {
    switch (this) {
      case Weekday.monday:
        return 'Monday';
      case Weekday.tuesday:
        return 'Tuesday';
      case Weekday.wednesday:
        return 'Wednesday';
      case Weekday.thursday:
        return 'Thursday';
      case Weekday.friday:
        return 'Friday';
      case Weekday.saturday:
        return 'Saturday';
      case Weekday.sunday:
        return 'Sunday';
    }
  }

  String get abbr {
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

  String get symbol {
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

  bool get isWeekend {
    switch (this) {
      case Weekday.saturday:
      case Weekday.sunday:
        return true;
      default:
        return false;
    }
  }

  bool get isWeekday => !isWeekend;
}

extension WeekdayListExtension on List<Weekday>? {
  String toDisplayString() {
    if (this == null) return 'Everyday';
    // if all days are selected, return 'Everyday'
    if (this!.length == 7) return 'Everyday';
    // if all weekdays are selected, return 'Weekdays'
    if (this!.length == 5 && !this!.contains(Weekday.saturday) && !this!.contains(Weekday.sunday)) return 'Weekdays';
    // if all weekends are selected, return 'Weekends'
    if (this!.length == 2 && this!.contains(Weekday.saturday) && this!.contains(Weekday.sunday)) return 'Weekends';
    // if only one day is selected, return the day's name
    if (this!.length == 1) return this![0].displayName;
    // if multiple days are selected, return the days' names
    return this!.map((e) => e.abbr).join(', ');
  }
}
