import 'package:flutter/material.dart';

abstract class ShapePainter extends CustomPainter {
  final Color color;
  final double shapeWidth;
  final double shapeHeight;

  ShapePainter({
    required this.color,
    required this.shapeWidth,
    required this.shapeHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (double x = -shapeWidth; x < size.width + shapeWidth; x += shapeWidth) {
      for (double y = -shapeHeight; y < size.height + shapeHeight; y += shapeHeight) {
        final offset = Offset(x, y);
        drawShape(canvas, offset, shapeWidth, shapeHeight, paint);
      }
    }
  }

  void drawShape(Canvas canvas, Offset offset, double width, double height, Paint paint);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 애니메이션이 동작하도록 함
  }
}
