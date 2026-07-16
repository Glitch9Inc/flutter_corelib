import 'package:flutter_corelib/flutter_corelib.dart';

/// A class representing a time range with optional constraints on start time,
/// end time, and duration. It supports validation, serialization, and utility
/// methods for checking overlaps and containment.
class TimeRange {
  /// A fallback value for start and end times when they are not set.
  static DateTime fallbackDateTime = DateTime(0);

  /// Represents an empty time range instance.
  static TimeRange empty = TimeRange(isEmpty: true);

  DateTime? _startTime;
  DateTime? _endTime;
  Duration? _duration;
  bool? _isStartTimeFixed;
  bool? _isEndTimeFixed;
  bool? _isDurationFixed;
  bool? _isEmpty;

  /// Checks if the start time is set.
  bool get isStartTimeSet => _startTime != null;

  /// Checks if the end time is set.
  bool get isEndTimeSet => _endTime != null;

  /// If true, the start time remains unchanged when the end time is modified.
  bool get isStartTimeFixed => _isStartTimeFixed ?? false;
  set isStartTimeFixed(bool value) => _isStartTimeFixed = value == false ? null : value;

  /// If true, the end time remains unchanged when the start time is modified.
  bool get isEndTimeFixed => _isEndTimeFixed ?? false;
  set isEndTimeFixed(bool value) => _isEndTimeFixed = value == false ? null : value;

  /// If true, the duration remains fixed when either the start or end time is modified.
  bool get isDurationFixed => _isDurationFixed ?? false;
  set isDurationFixed(bool value) => _isDurationFixed = value == false ? null : value;

  /// Returns true if this time range is considered invalid or empty.
  bool get isEmpty => _isEmpty ?? false;
  set isEmpty(bool value) => _isEmpty = value == false ? null : value;

  /// Checks if the start and end times are the same.
  bool get isZeroDuration => startTime == endTime;

  /// Gets the start time, using a fallback if not set.
  DateTime get startTime => _startTime ?? fallbackDateTime;
  set startTime(DateTime time) {
    _startTime = time;
    if (!_isValidRange()) {
      Debug.severe('End time must be after start time');
    } else {
      isEmpty = false;
    }
  }

  /// Gets the end time, using a fallback if not set.
  DateTime get endTime => _endTime ?? fallbackDateTime;
  set endTime(DateTime time) {
    _endTime = time;
    if (!_isValidRange()) {
      Debug.severe('End time must be after start time');
    } else {
      isEmpty = false;
    }
  }

  /// Constructor for initializing a time range with optional values.
  TimeRange({
    DateTime? start,
    DateTime? end,
    Duration? duration,
    bool? isEmpty,
    bool? isStartTimeFixed,
    bool? isEndTimeFixed,
    bool? isDurationFixed,
  }) {
    _startTime = start;
    _endTime = end;
    _duration = duration;
    _isEmpty = isEmpty;
    _isStartTimeFixed = isStartTimeFixed;
    _isEndTimeFixed = isEndTimeFixed;
    _isDurationFixed = isDurationFixed;

    if (!_isValidRange()) {
      Debug.severe('End time must be after start time');
      isEmpty = true;
    }
  }

  /// Factory constructor to create a `TimeRange` instance from JSON.
  factory TimeRange.fromJson(Map<String, dynamic> json) {
    if (json['empty'] == true) return TimeRange.empty;

    return TimeRange(
      start: json.getDateTimeOrNull('start'),
      end: json.getDateTimeOrNull('end'),
      duration: json.getDurationOrNull('duration'),
      isStartTimeFixed: json.getBool('fixed_start'),
      isEndTimeFixed: json.getBool('fixed_end'),
      isDurationFixed: json.getBool('fixed_dur'),
    );
  }

  /// Converts this object to a JSON representation.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (isEmpty) {
      json['empty'] = true;
      return json;
    }

    if (_startTime != null) json['start'] = _startTime!.toIso8601String();
    if (_endTime != null) json['end'] = _endTime!.toIso8601String();
    if (_duration != null) json['duration'] = _duration!.inSeconds;
    if (_isStartTimeFixed != null) json['fixed_start'] = _isStartTimeFixed;
    if (_isEndTimeFixed != null) json['fixed_end'] = _isEndTimeFixed;
    if (_isDurationFixed != null) json['fixed_dur'] = _isDurationFixed;

    return json;
  }

  /// Calculates the duration between start and end times.
  Duration get duration {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    return Duration(minutes: endMinutes - startMinutes);
  }

  /// Updates the end time based on a new duration.
  set duration(Duration duration) {
    endTime = startTime.add(duration);
    isEmpty = false;
  }

  /// Checks if a given time falls within this time range.
  bool contains(DateTime time) {
    final totalStartMinutes = startTime.hour * 60 + startTime.minute;
    final totalEndMinutes = endTime.hour * 60 + endTime.minute;
    final checkMinutes = time.hour * 60 + time.minute;

    return checkMinutes >= totalStartMinutes && checkMinutes <= totalEndMinutes;
  }

  /// Determines if this time range overlaps with another time range.
  bool overlaps(TimeRange other) {
    return contains(other.startTime) || contains(other.endTime);
  }

  /// Checks if this time range fully contains another time range.
  bool fullyContains(TimeRange other) {
    return contains(other.startTime) && contains(other.endTime);
  }

  /// Splits this time range when overlapping with another time range.
  void split(TimeRange other) {
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

  /// Returns a string representation of the time range.
  @override
  String toString() {
    if (isEmpty) return 'Empty Time Range';
    return '$startTime - $endTime';
  }

  /// Validates whether the start time is before the end time.
  bool _isValidRange() {
    return startTime.hour < endTime.hour || (startTime.hour == endTime.hour && startTime.minute < endTime.minute);
  }
}
