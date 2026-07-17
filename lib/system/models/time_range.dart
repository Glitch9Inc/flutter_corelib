/// Absolute date-time range using half-open `[start, end)` boundaries.
class TimeRange {
  static final DateTime fallbackDateTime = DateTime(0);
  static TimeRange get empty => TimeRange(isEmpty: true);

  DateTime? _startTime;
  DateTime? _endTime;
  Duration? _duration;
  bool? _isStartTimeFixed;
  bool? _isEndTimeFixed;
  bool? _isDurationFixed;
  bool isEmpty;

  TimeRange({
    DateTime? start,
    DateTime? end,
    Duration? duration,
    bool? isEmpty,
    bool? isStartTimeFixed,
    bool? isEndTimeFixed,
    bool? isDurationFixed,
  })  : _startTime = start,
        _endTime = end,
        _duration = duration,
        isEmpty = isEmpty ?? false,
        _isStartTimeFixed = isStartTimeFixed,
        _isEndTimeFixed = isEndTimeFixed,
        _isDurationFixed = isDurationFixed {
    if (_startTime != null && _endTime == null && duration != null) {
      _endTime = _startTime!.add(duration);
    } else if (_endTime != null && _startTime == null && duration != null) {
      _startTime = _endTime!.subtract(duration);
    }
    _validate();
  }

  factory TimeRange.fromJson(Map<String, dynamic> json) {
    if (json['empty'] == true) return TimeRange.empty;
    final start = _readDateTime(json['start']);
    final end = _readDateTime(json['end']);
    final duration = json['duration_ms'] is num
        ? Duration(milliseconds: (json['duration_ms'] as num).round())
        : json['duration'] is num
            ? Duration(seconds: (json['duration'] as num).round())
            : null;
    return TimeRange(
      start: start,
      end: end,
      duration: duration,
      isStartTimeFixed: json['fixed_start'] as bool?,
      isEndTimeFixed: json['fixed_end'] as bool?,
      isDurationFixed: json['fixed_dur'] as bool?,
    );
  }

  bool get isStartTimeSet => _startTime != null;
  bool get isEndTimeSet => _endTime != null;
  bool get isStartTimeFixed => _isStartTimeFixed ?? false;
  bool get isEndTimeFixed => _isEndTimeFixed ?? false;
  bool get isDurationFixed => _isDurationFixed ?? false;
  bool get isZeroDuration =>
      !isEmpty && isStartTimeSet && isEndTimeSet && startTime == endTime;

  set isStartTimeFixed(bool value) => _isStartTimeFixed = value ? true : null;
  set isEndTimeFixed(bool value) => _isEndTimeFixed = value ? true : null;
  set isDurationFixed(bool value) => _isDurationFixed = value ? true : null;
  DateTime get startTime => _startTime ?? fallbackDateTime;
  DateTime get endTime => _endTime ?? fallbackDateTime;

  set startTime(DateTime value) {
    if (_endTime != null && value.isAfter(_endTime!)) {
      throw ArgumentError.value(value, 'startTime', 'Must not follow endTime');
    }
    _startTime = value;
    isEmpty = false;
  }

  set endTime(DateTime value) {
    if (_startTime != null && value.isBefore(_startTime!)) {
      throw ArgumentError.value(value, 'endTime', 'Must not precede startTime');
    }
    _endTime = value;
    isEmpty = false;
  }

  Duration get duration {
    if (_startTime != null && _endTime != null) {
      return _endTime!.difference(_startTime!);
    }
    return _duration ?? Duration.zero;
  }

  set duration(Duration value) {
    if (value.isNegative) {
      throw ArgumentError.value(value, 'duration', 'Must not be negative');
    }
    _duration = value;
    if (_startTime != null) _endTime = _startTime!.add(value);
    isEmpty = false;
  }

  bool contains(DateTime value) {
    if (isEmpty || _startTime == null || _endTime == null) return false;
    return !value.isBefore(_startTime!) && value.isBefore(_endTime!);
  }

  bool overlaps(TimeRange other) {
    if (!_hasBounds || !other._hasBounds || isEmpty || other.isEmpty) {
      return false;
    }
    return _startTime!.isBefore(other._endTime!) &&
        other._startTime!.isBefore(_endTime!);
  }

  bool fullyContains(TimeRange other) {
    if (!_hasBounds || !other._hasBounds || isEmpty || other.isEmpty) {
      return false;
    }
    return !other._startTime!.isBefore(_startTime!) &&
        !other._endTime!.isAfter(_endTime!);
  }

  void split(TimeRange other) {
    if (!overlaps(other)) {
      throw ArgumentError('Time range does not overlap');
    }
    if (fullyContains(other) &&
        other.startTime.isAfter(startTime) &&
        other.endTime.isBefore(endTime)) {
      throw UnsupportedError(
        'Subtracting a middle range produces two ranges.',
      );
    }
    if (!other.startTime.isAfter(startTime)) {
      startTime = other.endTime;
    } else {
      endTime = other.startTime;
    }
  }

  Map<String, dynamic> toJson() {
    if (isEmpty) return <String, dynamic>{'empty': true};
    return <String, dynamic>{
      if (_startTime != null) 'start': _startTime!.toIso8601String(),
      if (_endTime != null) 'end': _endTime!.toIso8601String(),
      if (_duration != null) 'duration_ms': _duration!.inMilliseconds,
      if (_isStartTimeFixed != null) 'fixed_start': _isStartTimeFixed,
      if (_isEndTimeFixed != null) 'fixed_end': _isEndTimeFixed,
      if (_isDurationFixed != null) 'fixed_dur': _isDurationFixed,
    };
  }

  bool get _hasBounds => _startTime != null && _endTime != null;

  void _validate() {
    if (_duration?.isNegative ?? false) {
      throw ArgumentError.value(_duration, 'duration', 'Must not be negative');
    }
    if (_hasBounds && _endTime!.isBefore(_startTime!)) {
      throw ArgumentError('end must not precede start');
    }
  }

  static DateTime? _readDateTime(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    try {
      final converted = (value as dynamic).toDate();
      if (converted is DateTime) return converted;
    } on Object {
      // The strict error below includes the actual type.
    }
    throw FormatException('Expected DateTime-compatible value, got $value.');
  }

  @override
  String toString() => isEmpty ? 'Empty Time Range' : '$startTime - $endTime';
}
