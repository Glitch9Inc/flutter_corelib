import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

List<BoxShadow> getBoxShadow({Color? color, double radius = 2, double shadowOpacity = 0.25}) {
  color ??= Colors.black;
  return [
    BoxShadow(
      color: color.withOpacity(shadowOpacity),
      spreadRadius: radius,
      blurRadius: radius,
      offset: Offset(0, radius),
    )
  ];
}

List<BoxShadow> getBoxGlow({required Color glowColor, double radius = 2}) {
  glowColor = glowColor.saturate(.1);
  return [
    BoxShadow(
      color: glowColor,
      blurRadius: radius,
    ),
  ];
}

List<BoxShadow> getCastShadow({
  required Color color,
  double radius = 3,
  double opacity = 0.5,
  bool disabled = false,
}) {
  return [
    if (!disabled)
      BoxShadow(
        color: Colors.black.withOpacity(opacity),
        spreadRadius: 1,
        blurRadius: 1,
        offset: Offset(0, radius * 1.5),
      ),
    BoxShadow(
      color: color,
      offset: Offset(0, radius),
    )
  ];
}
