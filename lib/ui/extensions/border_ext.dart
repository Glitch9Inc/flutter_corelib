import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

extension BorderExt on Border {
  static Border top(double width, Color color, {bool includeSides = true}) {
    return Border(
      top: BorderSide(
        color: color,
        width: width,
      ),
      left: includeSides ? BorderSide(color: color, width: width) : BorderSide.none,
      right: includeSides ? BorderSide(color: color, width: width) : BorderSide.none,
    );
  }

  static Border bottom(double width, Color color, {bool includeSides = true}) {
    return Border(
      bottom: BorderSide(
        color: color,
        width: width,
      ),
      left: includeSides ? BorderSide(color: color, width: width) : BorderSide.none,
      right: includeSides ? BorderSide(color: color, width: width) : BorderSide.none,
    );
  }

  static Border left(double width, Color color, {bool includeSides = true}) {
    return Border(
      left: BorderSide(
        color: color,
        width: width,
      ),
      top: includeSides ? BorderSide(color: color, width: width) : BorderSide.none,
      bottom: includeSides ? BorderSide(color: color, width: width) : BorderSide.none,
    );
  }

  static Border right(double width, Color color, {bool includeSides = true}) {
    return Border(
      right: BorderSide(
        color: color,
        width: width,
      ),
      top: includeSides ? BorderSide(color: color, width: width) : BorderSide.none,
      bottom: includeSides ? BorderSide(color: color, width: width) : BorderSide.none,
    );
  }

  static Border sides(double width, Color color) {
    return Border(
      left: BorderSide(color: color, width: width),
      right: BorderSide(color: color, width: width),
    );
  }

  static Border? resolveBorder(ContainerOrder order, double width, Color color, {bool includeSides = true}) {
    if (order == ContainerOrder.top) {
      return top(width, color, includeSides: includeSides);
    } else if (order == ContainerOrder.bottom) {
      return bottom(width, color, includeSides: includeSides);
    }

    return sides(width, color);
  }
}
