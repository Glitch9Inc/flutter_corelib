import 'package:flutter/material.dart';

enum HalftoneType {
  circle,
  square,
  diamond,
}

class HalftoneGradientPainter extends CustomPainter {
  final HalftoneType type;
  final double halftoneSize;
  final Alignment begin;
  final Alignment end;
  final Color color;
  final List<double> stops;

  HalftoneGradientPainter({
    required this.type,
    required this.color,
    required this.halftoneSize,
    required this.begin,
    required this.end,
    required this.stops,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Offset beginOffset = Offset(
      begin.x * size.width / 2 + size.width / 2,
      begin.y * size.height / 2 + size.height / 2,
    );

    final Offset endOffset = Offset(
      end.x * size.width / 2 + size.width / 2,
      end.y * size.height / 2 + size.height / 2,
    );

    final int numDotsX = (size.width / halftoneSize).round() + 1;
    final int numDotsY = (size.height / halftoneSize).round() + 1;
    final double spacingX = size.width / (numDotsX - 1);
    final double spacingY = size.height / (numDotsY - 1);

    for (int i = 0; i < numDotsX; i++) {
      for (int j = 0; j < numDotsY; j++) {
        final Offset point = Offset(i * spacingX, j * spacingY);

        // Calculate the projection of the point onto the gradient line
        final double projection = ((point.dx - beginOffset.dx) * (endOffset.dx - beginOffset.dx) +
                (point.dy - beginOffset.dy) * (endOffset.dy - beginOffset.dy)) /
            (endOffset - beginOffset).distanceSquared;

        // Skip drawing if the projection exceeds the last stop
        if (projection > stops.last) {
          continue;
        }

        // Find the appropriate stop for the current projection
        double stopValue = 1.0;
        for (int k = 0; k < stops.length - 1; k++) {
          if (projection >= stops[k] && projection <= stops[k + 1]) {
            stopValue = 1 - (projection - stops[k]) / (stops[k + 1] - stops[k]);
            break;
          }
        }

        final double radius = stopValue * halftoneSize;

        if (radius > 0 && radius <= halftoneSize) {
          switch (type) {
            case HalftoneType.circle:
              canvas.drawCircle(point, radius, paint);
              break;
            case HalftoneType.square:
              canvas.drawRect(
                Rect.fromCenter(center: point, width: radius * 2, height: radius * 2),
                paint,
              );
              break;
            case HalftoneType.diamond:
              final double diamondRadius = radius * 1.25;
              final Path path = Path()
                ..moveTo(point.dx, point.dy - diamondRadius)
                ..lineTo(point.dx + diamondRadius, point.dy)
                ..lineTo(point.dx, point.dy + diamondRadius)
                ..lineTo(point.dx - diamondRadius, point.dy)
                ..close();
              canvas.drawPath(path, paint);
              break;
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
