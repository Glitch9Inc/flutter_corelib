import 'package:flutter/material.dart';

import 'time_of_day_range.dart';

/// Mutable collection of non-overlapping busy ranges for one local day.
class DaySchedule {
  final List<TimeOfDayRange> timeRanges;

  DaySchedule({required Iterable<TimeOfDayRange> timeRanges})
      : timeRanges = List<TimeOfDayRange>.of(timeRanges) {
    _normalize();
  }

  bool isAvailable(TimeOfDay time) {
    return !timeRanges.any((range) => range.contains(time));
  }

  bool isAvailableRange(TimeOfDayRange range) {
    return !timeRanges.any((existing) => existing.overlaps(range));
  }

  void add(TimeOfDayRange range) {
    if (range.isEmpty || range.isZeroDuration) {
      throw ArgumentError.value(range, 'range', 'Must have a duration');
    }
    if (!isAvailableRange(range)) {
      throw ArgumentError('Time range overlaps with an existing range');
    }
    timeRanges.add(range);
    _normalize();
  }

  void remove(TimeOfDayRange range) {
    if (range.isEmpty || range.isZeroDuration) return;
    final occupied = _occupancy();
    for (var minute = 0; minute < _minutesPerDay; minute++) {
      if (range.contains(_fromMinute(minute))) occupied[minute] = false;
    }
    _replaceFromOccupancy(occupied);
  }

  void _normalize() => _replaceFromOccupancy(_occupancy());

  List<bool> _occupancy() {
    return List<bool>.generate(
      _minutesPerDay,
      (minute) =>
          timeRanges.any((range) => range.contains(_fromMinute(minute))),
      growable: false,
    );
  }

  void _replaceFromOccupancy(List<bool> occupied) {
    final segments = <(int, int)>[];
    var minute = 0;
    while (minute < _minutesPerDay) {
      if (!occupied[minute]) {
        minute++;
        continue;
      }
      final start = minute;
      while (minute < _minutesPerDay && occupied[minute]) {
        minute++;
      }
      segments.add((start, minute));
    }

    timeRanges.clear();
    if (segments.length >= 2 &&
        segments.first.$1 == 0 &&
        segments.last.$2 == _minutesPerDay) {
      final overnight = TimeOfDayRange(
        start: _fromMinute(segments.last.$1),
        end: _fromMinute(segments.first.$2),
      );
      timeRanges.add(overnight);
      segments
        ..removeLast()
        ..removeAt(0);
    }

    for (final segment in segments) {
      timeRanges.add(
        TimeOfDayRange(
          start: _fromMinute(segment.$1),
          end: _fromMinute(segment.$2),
        ),
      );
    }
    timeRanges.sort(
      (first, second) =>
          _toMinute(first.startTime).compareTo(_toMinute(second.startTime)),
    );
  }

  static const int _minutesPerDay = 24 * 60;

  static int _toMinute(TimeOfDay value) => value.hour * 60 + value.minute;

  static TimeOfDay _fromMinute(int minute) {
    final normalized = minute % _minutesPerDay;
    return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
  }
}
