import 'package:flutter/material.dart';

import 'package:flutter_corelib/flutter_corelib.dart';

class HalftoneGradient {
  final HalftoneType type;
  final double halftoneSize;
  final Alignment begin;
  final Alignment end;
  final Color color;
  final List<double> stops;

  const HalftoneGradient({
    this.type = HalftoneType.circle,
    this.color = Colors.white,
    this.halftoneSize = 10,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.stops = const [0.0, 1.0],
  });
}
