import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class BackgroundGeometricPainter extends CustomPainter {
  final Animation<double> animation;
  final BackgroundGeometricType type;
  final BackgroundPanDirection direction;

  // draw 4 different sizes of shapes
  late final double tinySize;
  late final double smallSize;
  late final double mediumSize;
  late final double largeSize;

  late final Color tinyColor;
  late final Color smallColor;
  late final Color mediumColor;
  late final Color largeColor;

  BackgroundGeometricPainter({
    required this.animation,
    required this.type,
    required this.direction,
    required Color primaryColor,
    required Color secondaryColor,
    required double minSize,
    required double maxSize,
  }) : super(repaint: animation) {
    double sizeRange = maxSize - minSize;
    tinySize = minSize;
    smallSize = minSize + sizeRange * 0.25;
    mediumSize = minSize + sizeRange * 0.75;
    largeSize = maxSize;

    tinyColor = primaryColor;
    smallColor = primaryColor.withOpacity(.5);
    mediumColor = primaryColor.withOpacity(.4);
    largeColor = primaryColor.withOpacity(.3);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double animatedValue = animation.value;
    final double extraCoverage = largeSize * 2; // 추가로 덮을 영역 설정
    for (double y = -extraCoverage;
        y < size.height + extraCoverage;
        y += largeSize) {
      for (double x = -extraCoverage;
          x < size.width + extraCoverage;
          x += largeSize) {
        final Offset position = _calculatePosition(x, y, animatedValue, size);
        _drawPattern(canvas, size, position, animatedValue);
      }
    }
  }

  /// includes 2 tiny, 2 small, 1 medium (outline only), 1 large
  void _drawPattern(
      Canvas canvas, Size size, Offset position, double animatedValue) {
    _drawShape(canvas, position.translate(-tinySize, -tinySize), tinySize,
        tinyColor, false, animatedValue, 1.0, 2);
    // _drawShape(canvas, position.translate(tinySize, -tinySize), tinySize,
    //     tinyColor, false, animatedValue, 1.2, 2);
    _drawShape(canvas, position.translate(-smallSize, smallSize), smallSize,
        smallColor, false, animatedValue, 0.8, 2);
    _drawShape(canvas, position.translate(smallSize, smallSize), smallSize,
        smallColor, false, animatedValue, 1.1, 2);
    _drawShape(canvas, position, mediumSize, mediumColor, true, animatedValue,
        1.5, 40);
    _drawShape(canvas, position.translate(largeSize, largeSize), largeSize,
        largeColor, false, animatedValue, 0.9, 2);
  }

  Offset _calculatePosition(
      double x, double y, double animatedValue, Size size) {
    double dx = 0;
    double dy = 0;

    switch (direction) {
      case BackgroundPanDirection.toBottomLeft:
        dx = -animatedValue * size.width;
        dy = animatedValue * size.height;
        break;
      case BackgroundPanDirection.toBottomRight:
        dx = animatedValue * size.width;
        dy = animatedValue * size.height;
        break;
      case BackgroundPanDirection.toTopLeft:
        dx = -animatedValue * size.width;
        dy = -animatedValue * size.height;
        break;
      case BackgroundPanDirection.toTopRight:
        dx = animatedValue * size.width;
        dy = -animatedValue * size.height;
        break;
    }

    dx %= size.width;
    dy %= size.height;

    return Offset(x + dx, y + dy);
  }

  void _drawShape(
      Canvas canvas,
      Offset position,
      double size,
      Color color,
      bool outlineOnly,
      double animatedValue,
      double speedFactor,
      double spreadFactor) {
    final double adjustedAnimatedValue = animatedValue * speedFactor;
    final Offset adjustedPosition = _calculatePosition(
        position.dx, position.dy, adjustedAnimatedValue, Size(size, size));

    final paint = Paint()
      ..color = color
      ..style = outlineOnly ? PaintingStyle.stroke : PaintingStyle.fill
      ..strokeWidth = outlineOnly ? 2.0 : 0.0;

    switch (type) {
      case BackgroundGeometricType.circle:
        _drawCircle(canvas, adjustedPosition, size, paint);
        break;
      case BackgroundGeometricType.star:
        _drawStar(canvas, adjustedPosition, size, paint);
        break;
      case BackgroundGeometricType.square:
        _drawRotatedSquare(canvas, adjustedPosition, size, paint, 30);
        break;
    }
  }

  void _drawCircle(Canvas canvas, Offset position, double size, Paint paint) {
    canvas.drawCircle(position, size / 2, paint);
  }

  void _drawRotatedSquare(
      Canvas canvas, Offset position, double size, Paint paint, double angle) {
    canvas.save();
    // 회전 중심으로 이동
    canvas.translate(position.dx, position.dy);
    // 회전 적용
    canvas.rotate(angle);
    // 원래 위치로 이동 (회전된 상태)
    canvas.translate(-position.dx, -position.dy);

    // 사각형 경로 생성
    final path = Path()
      ..moveTo(position.dx - size / 2, position.dy - size / 2)
      ..lineTo(position.dx + size / 2, position.dy - size / 2)
      ..lineTo(position.dx + size / 2, position.dy + size / 2)
      ..lineTo(position.dx - size / 2, position.dy + size / 2)
      ..close();

    // 사각형 그리기
    canvas.drawPath(path, paint);

    // 변환 원래 상태로 되돌리기
    canvas.restore();
  }

  void _drawStar(Canvas canvas, Offset position, double size, Paint paint) {
    const int numPoints = 5;
    final double radius = size / 2;
    final double angle = (2 * pi) / numPoints;

    final path = Path();
    for (int i = 0; i < numPoints; i++) {
      final double x = position.dx + radius * cos(i * angle);
      final double y = position.dy + radius * sin(i * angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
