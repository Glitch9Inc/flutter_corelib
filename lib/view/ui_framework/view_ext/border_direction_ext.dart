import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

extension BorderDirectionExt on BorderDirection {
  BorderRadius resolveBorderRadius([double? borderRadius]) {
    double radius = borderRadius ?? 5;

    if (this == BorderDirection.all || this == BorderDirection.none) {
      return BorderRadius.circular(radius);
    }

    if (this == BorderDirection.top) {
      return BorderRadiusExt.circularTop(radius);
    }

    if (this == BorderDirection.bottom) {
      return BorderRadiusExt.circularBottom(radius);
    }

    if (this == BorderDirection.left) {
      return BorderRadiusExt.circularLeft(radius);
    }

    if (this == BorderDirection.right) {
      return BorderRadiusExt.circularRight(radius);
    }

    return BorderRadius.circular(radius);
  }

  Border? resolveBorder(Color color, [double width = 2, bool noneToAll = false]) {
    if (this == BorderDirection.none) {
      if (noneToAll) {
        return Border.all(
          width: width,
          color: color,
        );
      }
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
      );
    }

    if (this == BorderDirection.bottom) {
      return BorderExt.bottom(
        width,
        color,
      );
    }

    if (this == BorderDirection.left) {
      return BorderExt.left(
        width,
        color,
      );
    }

    if (this == BorderDirection.right) {
      return BorderExt.right(
        width,
        color,
      );
    }

    return Border.all(
      width: width,
      color: color,
    );
  }
}
