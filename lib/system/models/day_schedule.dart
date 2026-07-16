import 'package:flutter/material.dart';
import 'package:flutter_corelib/system/models/time_of_day_range.dart';

class DaySchedule {
  final List<TimeOfDayRange> timeRanges;

  DaySchedule({
    required this.timeRanges,
  });

  /// returns true if the given time is not in any of the time ranges
  bool isAvailable(TimeOfDay time) {
    return !timeRanges.any((range) => range.contains(time));
  }

  bool isAvailableRange(TimeOfDayRange range) {
    return !timeRanges.any((existingRange) => existingRange.overlaps(range));
  }

  void add(TimeOfDayRange range) {
    /// should not overlap with existing ranges

    if (!isAvailableRange(range)) {
      throw ArgumentError('Time range overlaps with existing ranges');
    }

    timeRanges.add(range);
    _rearrangeAll();
  }

  void remove(TimeOfDayRange range) {
    // remove the range that overlaps with the given range
    final rangesToRemove = timeRanges.where((existingRange) => existingRange.fullyContains(range));

    for (final rangeToRemove in rangesToRemove) {
      timeRanges.remove(rangeToRemove);
    }

    // remove the range that overlaps with the given range
    final rangesToSplit = timeRanges.where((existingRange) => existingRange.overlaps(range));

    for (final rangeToSplit in rangesToSplit) {
      rangeToSplit.split(range);
    }

    _rearrangeAll();
  }

  void _rearrangeAll() {
    // endtime과 startime이 겹치는 경우 합치기
    timeRanges.sort((a, b) => a.startTime.compareTo(b.startTime));

    for (var i = 0; i < timeRanges.length - 1; i++) {
      final current = timeRanges[i];
      final next = timeRanges[i + 1];

      if (current.overlaps(next)) {
        timeRanges.removeAt(i);
        timeRanges.removeAt(i);
        timeRanges.insert(i, TimeOfDayRange(start: current.startTime, end: next.endTime));
      }
    }
  }
}
