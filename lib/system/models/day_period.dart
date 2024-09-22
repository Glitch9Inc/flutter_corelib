enum DayPeriod {
  dawn,
  morning,
  afternoon,
  evening,
  night,
  lateNight,
}

extension DayPeriodExt on DayPeriod {
  String get name {
    switch (this) {
      case DayPeriod.dawn:
        return 'Dawn';
      case DayPeriod.morning:
        return 'Morning';
      case DayPeriod.afternoon:
        return 'Afternoon';
      case DayPeriod.evening:
        return 'Evening';
      case DayPeriod.night:
        return 'Night';
      case DayPeriod.lateNight:
        return 'Late Night';
    }
  }

  bool contains(DateTime dateTime) {
    switch (this) {
      case DayPeriod.dawn:
        return dateTime.hour >= 4 && dateTime.hour < 6;
      case DayPeriod.morning:
        return dateTime.hour >= 6 && dateTime.hour < 12;
      case DayPeriod.afternoon:
        return dateTime.hour >= 12 && dateTime.hour < 18;
      case DayPeriod.evening:
        return dateTime.hour >= 18 && dateTime.hour < 21;
      case DayPeriod.night:
        return dateTime.hour >= 21 || dateTime.hour < 4;
      case DayPeriod.lateNight:
        return dateTime.hour >= 2 && dateTime.hour < 4;
    }
  }
}
