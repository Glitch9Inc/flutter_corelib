import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

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

List<Shadow> getTextOutline([double width = 2, Color color = Colors.black]) {
  return [
    Shadow(
      color: color,
      offset: Offset(width, width),
      blurRadius: width,
    ),
    Shadow(
      color: color,
      offset: Offset(-width, width),
      blurRadius: width,
    ),
    Shadow(
      color: color,
      offset: Offset(width, -width),
      blurRadius: width,
    ),
    Shadow(
      color: color,
      offset: Offset(-width, -width),
      blurRadius: width,
    ),
    Shadow(
      color: color,
      offset: Offset(width, 0),
      blurRadius: width,
    ),
    Shadow(
      color: color,
      offset: Offset(-width, 0),
      blurRadius: width,
    ),
    Shadow(
      color: color,
      offset: Offset(0, width),
      blurRadius: width,
    ),
    Shadow(
      color: color,
      offset: Offset(0, -width),
      blurRadius: width,
    ),
  ];
}

List<Shadow> getDisplayTextOutline([double width = 2, Color color = Colors.black]) {
  return [
    Shadow(
      color: color,
      offset: Offset(width, width * 2),
      blurRadius: width,
    ),
    Shadow(
      color: color,
      offset: Offset(-width, width * 2),
      blurRadius: width,
    ),
    Shadow(
      color: color,
      offset: Offset(width, -width),
      blurRadius: width,
    ),
    Shadow(
      color: color,
      offset: Offset(-width, -width),
      blurRadius: width,
    ),
    Shadow(
      color: color,
      offset: Offset(width, 0),
      blurRadius: width,
    ),
    Shadow(
      color: color,
      offset: Offset(-width, 0),
      blurRadius: width,
    ),
    Shadow(
      color: color,
      offset: Offset(0, width * 2),
      blurRadius: width,
    ),
    Shadow(
      color: color,
      offset: Offset(0, -width),
      blurRadius: width,
    ),
  ];
}
