import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:flutter_corelib/view/ui_framework/models_enum/container_order.dart';

extension BorderRadiusExt on BorderRadius {
  static BorderRadius circularTop(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );
  }

  static BorderRadius circularBottom(double radius) {
    return BorderRadius.only(
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
  }

  static BorderRadius circularLeft(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
    );
  }

  static BorderRadius circularRight(double radius) {
    return BorderRadius.only(
      topRight: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
  }

  static BorderRadius? resolveCircular(ContainerOrder order, double radius) {
    if (order == ContainerOrder.top) {
      return circularTop(radius);
    } else if (order == ContainerOrder.bottom) {
      return circularBottom(radius);
    }

    return null;
  }
}
