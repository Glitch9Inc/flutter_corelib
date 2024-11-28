import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:flutter_corelib/ui/models/enum/container_order.dart';

extension BorderRadiusExt on BorderRadius {
  static BorderRadius top(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );
  }

  static BorderRadius bottom(double radius) {
    return BorderRadius.only(
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
  }

  static BorderRadius left(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
    );
  }

  static BorderRadius right(double radius) {
    return BorderRadius.only(
      topRight: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
  }

  static BorderRadius topLeft(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
    );
  }

  static BorderRadius topRight(double radius) {
    return BorderRadius.only(
      topRight: Radius.circular(radius),
    );
  }

  static BorderRadius bottomLeft(double radius) {
    return BorderRadius.only(
      bottomLeft: Radius.circular(radius),
    );
  }

  static BorderRadius bottomRight(double radius) {
    return BorderRadius.only(
      bottomRight: Radius.circular(radius),
    );
  }

  static BorderRadius? resolveCircular(ContainerOrder order, double radius) {
    if (order == ContainerOrder.top) {
      return top(radius);
    } else if (order == ContainerOrder.bottom) {
      return bottom(radius);
    }

    return null;
  }
}
