import 'package:intl/intl.dart';

class UnixTime {
  static final DateTime unixEpoch = DateTime(1970, 1, 1, 0, 0, 0, 0, 0);
  final int value;

  UnixTime.fromDateTime(DateTime dateTime) : value = dateTime.toUtc().difference(unixEpoch).inSeconds;

  UnixTime.fromUnixTimestamp(this.value);

  UnixTime.now() : value = DateTime.now().toUtc().difference(unixEpoch).inSeconds;

  UnixTime.empty() : value = 0;

  static UnixTime get today => UnixTime.fromDateTime(DateTime.now().toUtc());

  DateTime get toDateTime => unixEpoch.add(Duration(seconds: value));

  @override
  String toString() => value.toString();

  String toStringFormatted(String format) => DateFormat(format).format(toDateTime);

  // Operator overloads
  @override
  bool operator ==(Object other) => other is UnixTime && value == other.value;

  @override
  int get hashCode => value.hashCode;

  UnixTime operator +(UnixTime other) => UnixTime.fromUnixTimestamp(value + other.value);
  UnixTime operator -(UnixTime other) => UnixTime.fromUnixTimestamp(value - other.value);
  bool operator >(UnixTime other) => value > other.value;
  bool operator <(UnixTime other) => value < other.value;
  bool operator >=(UnixTime other) => value >= other.value;
  bool operator <=(UnixTime other) => value <= other.value;

  // Additional methods
  UnixTime addSeconds(int seconds) => UnixTime.fromUnixTimestamp(value + seconds);
  UnixTime addMinutes(int minutes) => addSeconds(minutes * 60);
  UnixTime addHours(int hours) => addMinutes(hours * 60);
  UnixTime addDays(int days) => addHours(days * 24);
}
