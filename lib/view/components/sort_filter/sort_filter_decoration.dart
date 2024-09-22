import 'package:flutter/material.dart';

class SortFilterDecoration {
  final Color sortTypeColor;
  final Color sortOrderColor;
  final Color filterColor;
  final Widget? decendingArrow;
  final Widget? ascendingArrow;
  final TextStyle? textStyle;
  final double borderRadius;
  final Color borderColor;
  final double? sortTypeWidth;
  final double? sortOrderWidth;
  final double? filterWidth;

  const SortFilterDecoration({
    this.sortTypeColor = Colors.indigo,
    this.sortOrderColor = Colors.deepOrange,
    this.filterColor = Colors.indigo,
    this.borderColor = Colors.cyan,
    this.decendingArrow,
    this.ascendingArrow,
    this.textStyle,
    this.borderRadius = 10,
    this.sortOrderWidth,
    this.sortTypeWidth,
    this.filterWidth,
  });
}
