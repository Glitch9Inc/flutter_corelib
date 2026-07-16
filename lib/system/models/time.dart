import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib_lib.dart';

class Time {
  final TimeOfDay start;
  final TimeOfDay end;

  Duration get duration => end.toDateTime().difference(start.toDateTime());

  const Time(this.start, this.end);

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      json.getTimeOfDay('start', defaultValue: TimeOfDay.now()),
      json.getTimeOfDay('end', defaultValue: TimeOfDay.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start.stringify(),
      'end': end.stringify(),
    };
  }

  Time copyWith({TimeOfDay? start, TimeOfDay? end}) {
    return Time(start ?? this.start, end ?? this.end);
  }

  @override
  String toString() {
    return '$start - $end';
  }
}
