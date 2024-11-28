import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

extension BorderDirectionExt on BorderDirection {
  BorderRadius resolveBorderRadius([double? borderRadius]) {
    double radius = borderRadius ?? 5;

    if (this == BorderDirection.none) {
      return BorderRadius.zero;
    }

    if (this == BorderDirection.all) {
      return BorderRadius.circular(radius);
    }

    if (this == BorderDirection.top) {
      return BorderRadiusExt.top(radius);
    }

    if (this == BorderDirection.bottom) {
      return BorderRadiusExt.bottom(radius);
    }

    if (this == BorderDirection.left) {
      return BorderRadiusExt.left(radius);
    }

    if (this == BorderDirection.right) {
      return BorderRadiusExt.right(radius);
    }

    if (this == BorderDirection.topLeft) {
      return BorderRadiusExt.topLeft(radius);
    }

    if (this == BorderDirection.topRight) {
      return BorderRadiusExt.topRight(radius);
    }

    if (this == BorderDirection.bottomLeft) {
      return BorderRadiusExt.bottomLeft(radius);
    }

    if (this == BorderDirection.bottomRight) {
      return BorderRadiusExt.bottomRight(radius);
    }

    return BorderRadius.circular(radius);
  }

  Border? resolveBorder(Color color, [double width = 1, bool noneToAll = false, bool includeSides = true]) {
    if (this == BorderDirection.none) {
      return null;
    }

    if (this == BorderDirection.all) {
      return Border.all(
        width: width,
        color: color,
      );
    }

    if (this == BorderDirection.top) {
      return BorderExt.top(
        width,
        color,
        includeSides: includeSides,
      );
    }

    if (this == BorderDirection.topOnly) {
      return BorderExt.top(
        width,
        color,
        includeSides: false,
      );
    }

    if (this == BorderDirection.bottom) {
      return BorderExt.bottom(
        width,
        color,
        includeSides: includeSides,
      );
    }

    if (this == BorderDirection.left) {
      return BorderExt.left(
        width,
        color,
        includeSides: includeSides,
      );
    }

    if (this == BorderDirection.right) {
      return BorderExt.right(
        width,
        color,
        includeSides: includeSides,
      );
    }

    return Border.all(
      width: width,
      color: color,
    );
  }
}
