import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_corelib/network/models/unix_time.dart';
import 'package:flutter_corelib/system/converters/enum_converter.dart';
import 'package:flutter_corelib/system/extensions/date_time_ext.dart';
import 'package:flutter_corelib/system/extensions/time_of_day_ext.dart';
import 'package:flutter_corelib/system/models/date_time_list.dart';
import 'package:flutter_corelib/system/models/day_schedule.dart';
import 'package:flutter_corelib/system/models/duration_range.dart';
import 'package:flutter_corelib/system/models/radian.dart';
import 'package:flutter_corelib/system/models/time_of_day_range.dart';
import 'package:flutter_corelib/system/models/time_range.dart';
import 'package:flutter_test/flutter_test.dart';

enum _Flag { zero, one, two }

void main() {
  test('UnixTime uses UTC epoch and supports negative timestamps', () {
    final epoch = UnixTime.fromDateTime(DateTime.utc(1970));
    final beforeEpoch =
        UnixTime.fromDateTime(DateTime.utc(1969, 12, 31, 23, 59, 59));

    expect(epoch.value, 0);
    expect(beforeEpoch.value, -1);
    expect(beforeEpoch.toDateTime, DateTime.utc(1969, 12, 31, 23, 59, 59));
    expect(epoch.difference(beforeEpoch), const Duration(seconds: 1));
  });

  test('enum bit flags are symmetric including empty and index zero', () {
    expect(EnumConverter.enumListToFlag(<_Flag>[]), 0);
    expect(EnumConverter.enumListToFlag(<_Flag>[_Flag.zero]), 1);

    final flag = EnumConverter.enumListToFlag(<_Flag>[_Flag.zero, _Flag.two]);
    expect(
      EnumConverter.flagToEnumList(flag, _Flag.values),
      <_Flag>[_Flag.zero, _Flag.two],
    );
  });

  test('absolute ranges use dates and half-open symmetric overlap', () {
    final first = TimeRange(
      start: DateTime.utc(2026, 7, 17, 23),
      end: DateTime.utc(2026, 7, 18, 2),
    );
    final contained = TimeRange(
      start: DateTime.utc(2026, 7, 18),
      end: DateTime.utc(2026, 7, 18, 1),
    );
    final touching = TimeRange(
      start: DateTime.utc(2026, 7, 18, 2),
      end: DateTime.utc(2026, 7, 18, 3),
    );

    expect(first.duration, const Duration(hours: 3));
    expect(first.overlaps(contained), isTrue);
    expect(contained.overlaps(first), isTrue);
    expect(first.fullyContains(contained), isTrue);
    expect(first.overlaps(touching), isFalse);
    expect(first.contains(first.endTime), isFalse);
  });

  test('time range JSON writes milliseconds and reads legacy seconds', () {
    final range = TimeRange(
      start: DateTime.utc(2026, 7, 17),
      duration: const Duration(milliseconds: 1500),
    );
    final json = range.toJson();
    expect(json['duration_ms'], 1500);
    expect(
        TimeRange.fromJson(json).duration, const Duration(milliseconds: 1500));

    final legacy = TimeRange.fromJson(<String, dynamic>{
      'start': DateTime.utc(2026, 7, 17).toIso8601String(),
      'duration': 90,
    });
    expect(legacy.duration, const Duration(seconds: 90));
  });

  test('overnight time-of-day ranges contain and overlap correctly', () {
    final overnight = TimeOfDayRange(
      start: const TimeOfDay(hour: 23, minute: 0),
      end: const TimeOfDay(hour: 2, minute: 0),
    );
    final afterMidnight = TimeOfDayRange(
      start: const TimeOfDay(hour: 1, minute: 0),
      end: const TimeOfDay(hour: 3, minute: 0),
    );
    final daytime = TimeOfDayRange(
      start: const TimeOfDay(hour: 12, minute: 0),
      end: const TimeOfDay(hour: 13, minute: 0),
    );

    expect(overnight.duration, const Duration(hours: 3));
    expect(overnight.contains(const TimeOfDay(hour: 23, minute: 30)), isTrue);
    expect(overnight.contains(const TimeOfDay(hour: 1, minute: 30)), isTrue);
    expect(overnight.contains(const TimeOfDay(hour: 2, minute: 0)), isFalse);
    expect(overnight.overlaps(afterMidnight), isTrue);
    expect(overnight.overlaps(daytime), isFalse);
  });

  test('DaySchedule subtracts a middle range without concurrent mutation', () {
    final schedule = DaySchedule(timeRanges: <TimeOfDayRange>[
      TimeOfDayRange(
        start: const TimeOfDay(hour: 9, minute: 0),
        end: const TimeOfDay(hour: 12, minute: 0),
      ),
    ]);
    schedule.remove(
      TimeOfDayRange(
        start: const TimeOfDay(hour: 10, minute: 0),
        end: const TimeOfDay(hour: 11, minute: 0),
      ),
    );

    expect(schedule.timeRanges, hasLength(2));
    expect(schedule.isAvailable(const TimeOfDay(hour: 10, minute: 30)), isTrue);
    expect(schedule.isAvailable(const TimeOfDay(hour: 9, minute: 30)), isFalse);
  });

  test('date helpers use receiver, ISO week, and clamped month', () {
    final wednesday = DateTime(2026, 7, 15, 18);
    expect(
      wednesday.getStartOfWeek(DateTime.monday),
      DateTime(2026, 7, 13),
    );
    expect(wednesday.getEndOfWeek(DateTime.monday), DateTime(2026, 7, 19));
    expect(DateTime(2021, 1, 1).weekOfYear, 53);
    expect(DateTime(2026, 1, 31).nextMonth, DateTime(2026, 2, 28));
  });

  test('time display and negative addition are normalized', () {
    const afternoon = TimeOfDay(hour: 13, minute: 5);
    expect(afternoon.toDisplayString(), '1:05 PM');
    expect(
      const TimeOfDay(hour: 0, minute: 15).add(const Duration(minutes: -30)),
      const TimeOfDay(hour: 23, minute: 45),
    );
    expect('23:59'.tryToTimeOfDay(), const TimeOfDay(hour: 23, minute: 59));
    expect('24:00'.tryToTimeOfDay(), isNull);
  });

  test('value equality/hash and conversions are stable', () {
    final first = DateTimeList<int>()..add(DateTime.utc(2026), 1);
    final second = DateTimeList<int>()..add(DateTime.utc(2026), 1);
    expect(first, second);
    expect(first.hashCode, second.hashCode);
    expect(DateTimeList<int>().hashCode, isA<int>());

    for (final hour in <double>[0, 3, 6, 9, 12]) {
      final converted = Radian.fromClockHour(hour).toClockHour();
      expect(converted, closeTo(hour % 12, 0.000001));
    }

    const range = DurationRange(
      min: Duration(seconds: 1),
      max: Duration(seconds: 2),
    );
    final sample = range.sample(Random(7));
    expect(sample >= range.min && sample <= range.max, isTrue);
  });
}
