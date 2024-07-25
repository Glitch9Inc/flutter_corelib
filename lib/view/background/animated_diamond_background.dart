import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class AnimatedDiamondBackground extends StatefulWidget {
  final Color color;
  final Color backgroundColor;
  final double diamondHeight;
  final double diamondWidth;
  final BackgroundPanDirection direction;

  const AnimatedDiamondBackground({
    Key? key,
    required this.color,
    required this.backgroundColor,
    this.direction = BackgroundPanDirection.toBottomLeft,
    this.diamondHeight = 100,
    this.diamondWidth = 100,
  }) : super(key: key);

  @override
  _AnimatedDiamondBackgroundState createState() =>
      _AnimatedDiamondBackgroundState();
}

class _AnimatedDiamondBackgroundState extends State<AnimatedDiamondBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  Offset _getOffset(double value) {
    switch (widget.direction) {
      case BackgroundPanDirection.toTopLeft:
        return Offset(-value, -value);
      case BackgroundPanDirection.toTopRight:
        return Offset(value, -value);
      case BackgroundPanDirection.toBottomRight:
        return Offset(value, value);
      case BackgroundPanDirection.toBottomLeft:
      default:
        return Offset(-value, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              for (double dx = -1.0; dx <= 1.0; dx++)
                for (double dy = -1.0; dy <= 1.0; dy++)
                  Transform.translate(
                    offset: _getOffset(_controller.value * 100) +
                        Offset(dx * 100, dy * 100),
                    child: child,
                  ),
            ],
          );
        },
        child: CustomPaint(
          painter: DiamondPainter(
            color: widget.color,
            diamondWidth: widget.diamondWidth,
            diamondHeight: widget.diamondHeight,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class DiamondPainter extends CustomPainter {
  final Color color;
  final double diamondWidth;
  final double diamondHeight;

  DiamondPainter({
    required this.color,
    required this.diamondWidth,
    required this.diamondHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (double x = -diamondWidth;
        x < size.width + diamondWidth;
        x += diamondWidth) {
      for (double y = -diamondHeight;
          y < size.height + diamondHeight;
          y += diamondHeight) {
        final offset = Offset(x, y);

        // 다이아몬드 그리기
        _drawDiamond(canvas, offset, diamondWidth, diamondHeight, paint);
      }
    }
  }

  void _drawDiamond(
      Canvas canvas, Offset offset, double width, double height, Paint paint) {
    final path = Path()
      ..moveTo(offset.dx + width / 2, offset.dy)
      ..lineTo(offset.dx + width, offset.dy + height / 2)
      ..lineTo(offset.dx + width / 2, offset.dy + height)
      ..lineTo(offset.dx, offset.dy + height / 2)
      ..close();

    paint.color = color; // 모든 다이아몬드를 같은 색으로 칠함
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 애니메이션이 동작하도록 함
  }
}
