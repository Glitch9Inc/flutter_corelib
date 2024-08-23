import 'package:flutter/material.dart';

class Dot {
  final IconData? icon;
  final Color color;
  Dot({this.icon, required this.color});
}

class FilterDot<T> extends Dot {
  final T value;
  FilterDot({super.icon, required super.color, required this.value});
}
