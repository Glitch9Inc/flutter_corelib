import 'package:flutter/material.dart';

abstract class TextSpanUtil {
  static TextSpan blankLine({double height = 0.4}) {
    return TextSpan(
      text: '\n',
      style: TextStyle(
        height: height,
      ),
    );
  }
}
