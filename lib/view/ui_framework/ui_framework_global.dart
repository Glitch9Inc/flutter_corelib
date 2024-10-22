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

List<BoxShadow> getCartoonBoxShadow({
  required Color color,
  double thickness = 3,
  double shadowOpacity = 0.5,
  bool noShadow = false,
}) {
  return [
    if (!noShadow)
      BoxShadow(
        color: Colors.black.withOpacity(shadowOpacity),
        spreadRadius: 1,
        blurRadius: 1,
        offset: Offset(0, thickness * 1.5),
      ),
    BoxShadow(
      color: color,
      offset: Offset(0, thickness),
    )
  ];
}

List<Shadow> getTextShadow({double size = 2}) {
  return [
    Shadow(
      color: Colors.black,
      offset: Offset(size / 2, size),
      blurRadius: size,
    ),
  ];
}

List<Shadow> getTextGlow(Color color, double blurRadius) {
  return [
    Shadow(
      color: color,
      blurRadius: blurRadius,
    ),
  ];
}

/// 배경때문에 텍스트가 잘 안보일 때 사용
List<Shadow> getTextPopShadow(Color color, double radius, {int intencity = 2}) {
  final adjustedColor = color.saturate(0.5);

  Shadow create(int intencity) {
    return Shadow(
      color: adjustedColor,
      blurRadius: radius * intencity,
    );
  }

  return List.generate(intencity, (index) => create(index + 1));
}

List<Shadow> getTextOutline([double strokeWidth = 2, Color strokeColor = Colors.black]) {
  return [
    Shadow(
      color: strokeColor,
      offset: Offset(strokeWidth, strokeWidth),
      blurRadius: strokeWidth,
    ),
    Shadow(
      color: strokeColor,
      offset: Offset(-strokeWidth, strokeWidth),
      blurRadius: strokeWidth,
    ),
    Shadow(
      color: strokeColor,
      offset: Offset(strokeWidth, -strokeWidth),
      blurRadius: strokeWidth,
    ),
    Shadow(
      color: strokeColor,
      offset: Offset(-strokeWidth, -strokeWidth),
      blurRadius: strokeWidth,
    ),
    Shadow(
      color: strokeColor,
      offset: Offset(strokeWidth, 0),
      blurRadius: strokeWidth,
    ),
    Shadow(
      color: strokeColor,
      offset: Offset(-strokeWidth, 0),
      blurRadius: strokeWidth,
    ),
    Shadow(
      color: strokeColor,
      offset: Offset(0, strokeWidth),
      blurRadius: strokeWidth,
    ),
    Shadow(
      color: strokeColor,
      offset: Offset(0, -strokeWidth),
      blurRadius: strokeWidth,
    ),
  ];
}

Border? getBorder(bool condition) => condition
    ? Border.all(
        color: routinaGreenW100,
        width: 3,
      )
    : null;
