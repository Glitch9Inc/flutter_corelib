import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension IntExt on int {
  get secs => Duration(seconds: this);
  get millis => Duration(milliseconds: this);
  get color => Colors.primaries[(this + 1) % Colors.primaries.length].withAlpha(150);
  get formattedString {
    final formatter = NumberFormat('#,###');
    return formatter.format(this);
  }

  String toStringWithComma() {
    return NumberFormat('#,###').format(this);
  }

  String toRewardAmountString() {
    if (this < 1000) {
      return toString();
    } else if (this < 1000000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    }
  }
}
