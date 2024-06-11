import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String toFormattedString(String format) {
    return DateFormat(format).format(this);
  }
}
