import 'package:flutter/material.dart';

import 'shape_painter.dart';

class DiamondPainter extends ShapePainter {
  DiamondPainter({
    required super.color,
    required super.shapeWidth,
    required super.shapeHeight,
  }) : super();

  @override
  void drawShape(Canvas canvas, Offset offset, double width, double height, Paint paint) {
    final path = Path()
      ..moveTo(offset.dx + width / 2, offset.dy)
      ..lineTo(offset.dx + width, offset.dy + height / 2)
      ..lineTo(offset.dx + width / 2, offset.dy + height)
      ..lineTo(offset.dx, offset.dy + height / 2)
      ..close();

    paint.color = color;
    canvas.drawPath(path, paint);
  }
}
