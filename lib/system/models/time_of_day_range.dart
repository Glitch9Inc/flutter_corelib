import 'package:flutter/material.dart';

import '../extensions/time_of_day_ext.dart';

/// Recurring local time range using half-open `[start, end)` boundaries.
///
/// A range whose end precedes its start crosses midnight. A range with neither
/// boundary represents an all-day/unspecified schedule for compatibility.
class TimeOfDayRange {
  static const TimeOfDay kEmptyTimeOfDay = TimeOfDay(hour: 0, minute: 0);
  static TimeOfDayRange get empty => TimeOfDayRange();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  TimeOfDayRange({TimeOfDay? start, TimeOfDay? end})
      : _startTime = start,
        _endTime = end {
    if ((start == null) != (end == null)) {
      throw ArgumentError('start and end must either both be set or both null');
    }
  }

  factory TimeOfDayRange.fromDateTime({DateTime? start, DateTime? end}) {
    return TimeOfDayRange(
      start: start == null ? null : TimeOfDay.fromDateTime(start),
      end: end == null ? null : TimeOfDay.fromDateTime(end),
    );
  }

  factory TimeOfDayRange.fromJson(Map<String, dynamic> json) {
    if (json['empty'] == true) return TimeOfDayRange.empty;
    final start = _readDateTime(json['start']);
    final end = _readDateTime(json['end']);
    return TimeOfDayRange.fromDateTime(start: start, end: end);
  }

  bool get isStartTimeSet => _startTime != null;
  bool get isEndTimeSet => _endTime != null;
  bool get isAllDay => isEmpty;
  bool get isEmpty => _startTime == null && _endTime == null;
  bool get isNextDay => !isEmpty && _endMinute < _startMinute;
  bool get isZeroDuration => !isEmpty && _startMinute == _endMinute;

  TimeOfDay get startTime => _startTime ?? kEmptyTimeOfDay;
  TimeOfDay get endTime => _endTime ?? kEmptyTimeOfDay;

  set startTime(TimeOfDay value) => _startTime = value;
  set endTime(TimeOfDay value) => _endTime = value;

  Duration get duration {
    if (isEmpty) return const Duration(days: 1);
    var end = _endMinute;
    if (end < _startMinute) end += _minutesPerDay;
    return Duration(minutes: end - _startMinute);
  }

  set duration(Duration value) {
    if (value.isNegative || value > const Duration(days: 1)) {
      throw ArgumentError.value(
        value,
        'duration',
        'Must be between zero and one day',
      );
    }
    if (_startTime == null) {
      throw StateError('Cannot set duration without a start time');
    }
    endTime = startTime.add(value);
  }

  bool contains(TimeOfDay value) {
    if (isEmpty || isZeroDuration) return false;
    final minute = value.hour * 60 + value.minute;
    return _segments.any(
      (segment) => minute >= segment.$1 && minute < segment.$2,
    );
  }

  bool overlaps(TimeOfDayRange other) {
    if (isEmpty || other.isEmpty) return false;
    for (final first in _segments) {
      for (final second in other._segments) {
        if (first.$1 < second.$2 && second.$1 < first.$2) return true;
      }
    }
    return false;
  }

  bool fullyContains(TimeOfDayRange other) {
    if (isEmpty || other.isEmpty) return false;
    return other._segments.every(
      (otherSegment) => _segments.any(
        (segment) =>
            segment.$1 <= otherSegment.$1 && segment.$2 >= otherSegment.$2,
      ),
    );
  }

  void split(TimeOfDayRange other) {
    if (!overlaps(other)) {
      throw ArgumentError('Time range does not overlap');
    }
    final remaining = _subtractSegments(_segments, other._segments);
    if (remaining.length != 1) {
      throw UnsupportedError(
        'Subtracting this range produces ${remaining.length} ranges.',
      );
    }
    _startTime = _fromMinute(remaining.single.$1);
    _endTime = _fromMinute(remaining.single.$2 % _minutesPerDay);
  }

  String stringify() {
    if (isEmpty) return '';
    final sameAmPm = startTime.period == endTime.period;
    return '${startTime.stringify(use24HourFormat: true, hidePeriod: sameAmPm)}'
        ' - ${endTime.stringify(use24HourFormat: true)}';
  }

  Map<String, dynamic> toJson() {
    if (isEmpty) return <String, dynamic>{'empty': true};
    return <String, dynamic>{
      'start': startTime.toIso8601String(),
      'end': endTime.toIso8601String(),
    };
  }

  @override
  String toString({bool use24HourFormat = true}) {
    if (isEmpty) return '';
    final sameAmPm = startTime.period == endTime.period;
    return '${startTime.stringify(
      use24HourFormat: use24HourFormat,
      hidePeriod: sameAmPm,
    )} - ${endTime.stringify(use24HourFormat: use24HourFormat)}';
  }

  int get _startMinute => startTime.hour * 60 + startTime.minute;
  int get _endMinute => endTime.hour * 60 + endTime.minute;

  List<(int, int)> get _segments {
    if (isEmpty || isZeroDuration) return const <(int, int)>[];
    if (_endMinute > _startMinute) {
      return <(int, int)>[(_startMinute, _endMinute)];
    }
    return <(int, int)>[
      (_startMinute, _minutesPerDay),
      (0, _endMinute),
    ];
  }

  static const int _minutesPerDay = 24 * 60;

  static TimeOfDay _fromMinute(int minute) {
    final normalized = minute % _minutesPerDay;
    return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
  }

  static List<(int, int)> _subtractSegments(
    List<(int, int)> source,
    List<(int, int)> removed,
  ) {
    var result = List<(int, int)>.of(source);
    for (final cut in removed) {
      final next = <(int, int)>[];
      for (final segment in result) {
        if (cut.$2 <= segment.$1 || cut.$1 >= segment.$2) {
          next.add(segment);
          continue;
        }
        if (cut.$1 > segment.$1) next.add((segment.$1, cut.$1));
        if (cut.$2 < segment.$2) next.add((cut.$2, segment.$2));
      }
      result = next;
    }
    return result;
  }

  static DateTime? _readDateTime(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    try {
      final converted = (value as dynamic).toDate();
      if (converted is DateTime) return converted;
    } on Object {
      // Fall through to the strict parse error.
    }
    throw FormatException('Expected DateTime-compatible value, got $value.');
  }
}
