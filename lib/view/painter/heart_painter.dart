import 'package:flutter/material.dart';

import 'shape_painter.dart';

class HeartPainter extends ShapePainter {
  HeartPainter({
    required super.color,
    required super.shapeWidth,
    required super.shapeHeight,
  }) : super();

  @override
  void drawShape(Canvas canvas, Offset offset, double width, double height, Paint paint) {
    final path = Path();

    double pointiness = 0.8; // how pointy the bottom of the heart is
    double curviness = 0.6; // how fat the heart is
    double sizeAdjustment = 0;
    double inverseSizeAdjustment = 1 - sizeAdjustment;

    // Start from the bottom center of the heart
    path.moveTo(offset.dx + width / 2, offset.dy + height * pointiness);

    // Left curve of the heart
    path.cubicTo(
      offset.dx + width * sizeAdjustment, offset.dy + height * curviness, // Control point 1 (left)
      offset.dx + width * sizeAdjustment, offset.dy + height * sizeAdjustment, // Control point 2 (top left)
      offset.dx + width / 2, offset.dy + height * 0.3, // End point (top center)
    );

    // Right curve of the heart
    path.cubicTo(
      offset.dx + width * inverseSizeAdjustment, offset.dy + height * sizeAdjustment, // Control point 1 (top right)
      offset.dx + width * inverseSizeAdjustment, offset.dy + height * curviness, // Control point 2 (right)
      offset.dx + width / 2, offset.dy + height * pointiness, // End point (bottom center)
    );

    path.close();

    paint.color = color;
    canvas.drawPath(path, paint);
  }
}
