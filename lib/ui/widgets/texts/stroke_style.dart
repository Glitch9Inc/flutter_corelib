import 'package:flutter/material.dart';
import 'package:flutter_corelib/ui/widgets/texts/stroke_text.dart';

class StrokeStyle {
  final double? width;
  final Color? color;
  final StrokeType type;
  final int intensity;

  const StrokeStyle({
    this.width,
    this.color,
    this.type = StrokeType.outline,
    this.intensity = 2,
  });

  factory StrokeStyle.defaultInner() {
    return const StrokeStyle(
      color: Colors.black,
      type: StrokeType.outline,
      intensity: 2,
    );
  }

  factory StrokeStyle.defaultOuter() {
    return const StrokeStyle(
      color: Colors.white,
      type: StrokeType.outline,
      intensity: 2,
    );
  }
}
