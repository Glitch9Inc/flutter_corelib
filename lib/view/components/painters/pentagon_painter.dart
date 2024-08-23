import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_corelib/flutter_corelib.dart';

class PentagonContainer extends StatelessWidget {
  final double size;
  final Color color;
  final Widget? child;
  final List<Shadow>? shadows;

  const PentagonContainer({
    super.key,
    this.size = 100,
    this.color = transparentWhiteW500,
    this.shadows,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: PentagonPainter(
            color: color,
            glowColor: color,
            glowSigma: 0,
            shadows: shadows,
          ),
          size: Size.square(size),
        ),
        if (child != null)
          Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            child: child,
          ),
      ],
    );
  }
}

class PentagonPainter extends CustomPainter {
  final Color color;
  final Color glowColor; // 글로우 색상
  final double glowSigma; // 글로우 효과의 시그마 값
  final List<Shadow>? shadows;

  PentagonPainter({
    this.color = transparentWhiteW500,
    this.glowColor = Colors.transparent,
    this.glowSigma = 0,
    this.shadows,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Pentagon path
    var path = Path();

    var angle = -pi / 2;
    var radius = min(size.width / 2, size.height / 2);
    var center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 5; i++) {
      var x = center.dx + radius * cos(angle);
      var y = center.dy + radius * sin(angle);
      var point = Offset(x, y);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
      angle += 2 * pi / 5;
    }
    path.close();

    // Apply shadows
    if (shadows != null) {
      for (var shadow in shadows!) {
        var shadowPaint = paint
          ..color = shadow.color
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurRadius);
        canvas.save();
        canvas.translate(shadow.offset.dx, shadow.offset.dy);
        canvas.drawPath(path, shadowPaint);
        canvas.restore();
      }
    }

    // Draw pentagon shape
    canvas.drawPath(path, paint);

    // Apply glow effect if required
    if (glowSigma > 0) {
      var borderPaint = Paint()
        ..color = glowColor
        ..strokeWidth = 1.0 // Border thickness
        ..style = PaintingStyle.stroke // Draw only the border
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowSigma); // Apply glow effect

      canvas.drawPath(path, borderPaint); // Draw border with glow effect
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
