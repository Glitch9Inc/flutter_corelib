import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class TimeOfDayRange {
  static const TimeOfDay kEmptyTimeOfDay = TimeOfDay(hour: 0, minute: 0);
  static TimeOfDayRange empty = TimeOfDayRange();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool get isStartTimeSet => _startTime != null;
  bool get isEndTimeSet => _endTime != null;
  bool get isAllDay => _startTime == null || _endTime == null;

  /// Returns true if this time range is supposed to mean invalid or empty.
  bool get isEmpty => _startTime == null && _endTime == null;

  /// Returns true if the end time is on the next day.
  bool get isNextDay => endTime.hour < startTime.hour;

  /// Returns true if the start time and end time are the same.
  bool get isZeroDuration => startTime == endTime;

  TimeOfDay get startTime => _startTime ?? kEmptyTimeOfDay;
  set startTime(TimeOfDay time) => _startTime = time;

  TimeOfDay get endTime => _endTime ?? kEmptyTimeOfDay;
  set endTime(TimeOfDay time) => _endTime = time;

  TimeOfDayRange({TimeOfDay? start, TimeOfDay? end}) {
    _startTime = start;
    _endTime = end;
  }

  factory TimeOfDayRange.fromDateTime({DateTime? start, DateTime? end}) {
    return TimeOfDayRange(
      start: start != null ? TimeOfDay.fromDateTime(start) : null,
      end: end != null ? TimeOfDay.fromDateTime(end) : null,
    );
  }

  String stringify() {
    if (isEmpty) return '';

    final sameAmPm = startTime.period == endTime.period;
    return '${startTime.stringify(use24HourFormat: true, hidePeriod: sameAmPm)} - ${endTime.stringify(use24HourFormat: true)}';
  }

  factory TimeOfDayRange.fromJson(Map<String, dynamic> json) {
    if (json['empty'] == true) return TimeOfDayRange.empty;

    return TimeOfDayRange.fromDateTime(
      start: json.getDateTimeOrNull('start'),
      end: json.getDateTimeOrNull('end'),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (_startTime != null) json['start'] = _startTime!.toIso8601String();
    if (_endTime != null) json['end'] = _endTime!.toIso8601String();

    return json;
  }

  Duration get duration {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = endTime.hour * 60 + endTime.minute;
    if (isNextDay) endMinutes += 24 * 60;
    return Duration(minutes: endMinutes - startMinutes);
  }

  set duration(Duration duration) {
    endTime = startTime.add(duration);
  }

  bool contains(TimeOfDay time) {
    final totalStartMinutes = startTime.hour * 60 + startTime.minute;
    final totalEndMinutes = endTime.hour * 60 + endTime.minute;
    final checkMinutes = time.hour * 60 + time.minute;

    return checkMinutes >= totalStartMinutes && checkMinutes <= totalEndMinutes;
  }

  bool overlaps(TimeOfDayRange other) {
    return contains(other.startTime) || contains(other.endTime);
  }

  bool fullyContains(TimeOfDayRange other) {
    return contains(other.startTime) && contains(other.endTime);
  }

  void split(TimeOfDayRange other) {
    if (!overlaps(other)) {
      throw ArgumentError('Time range does not overlap');
    }

    if (contains(other.startTime) && contains(other.endTime)) {
      throw ArgumentError('Time range is fully contained');
    }

    if (contains(other.startTime)) {
      startTime = other.endTime;
    } else {
      endTime = other.startTime;
    }
  }

  /// DO NOT USE 'use24HourFormat = false' for saving the time range in the database.
  /// 'use24HourFormat = false' is for UI purposes only.
  @override
  String toString({bool use24HourFormat = true}) {
    if (isEmpty) return '10:00 AM - 12:00 PM';

    final sameAmPm = startTime.period == endTime.period;
    return '${startTime.stringify(use24HourFormat: use24HourFormat, hidePeriod: sameAmPm)} - ${endTime.stringify(use24HourFormat: use24HourFormat)}';
  }
}
