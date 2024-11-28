import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:flutter_corelib/ui/widgets/backgrounds/background_geometric_painter.dart';

enum BackgroundGeometricType {
  circle,
  star,
  square,
}

class AnimatedGeometricBackground extends StatefulWidget {
  final BackgroundGeometricType type;
  final BackgroundPanDirection direction;
  final Color primaryColor;
  final Color secondaryColor;
  final double minSize;
  final double maxSize;
  final double speed;

  const AnimatedGeometricBackground({
    super.key,
    required this.type,
    required this.direction,
    required this.primaryColor,
    required this.secondaryColor,
    this.minSize = 100,
    this.maxSize = 240,
    this.speed = 1,
  });

  @override
  State<AnimatedGeometricBackground> createState() => _AnimatedGeometricBackgroundState();
}

class _AnimatedGeometricBackgroundState extends State<AnimatedGeometricBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (30 / widget.speed).toInt()),
    )..repeat();
  }

  Stack _buildStack() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                widget.primaryColor,
                widget.secondaryColor,
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: BackgroundGeometricPainter(
                animation: _controller,
                type: widget.type,
                direction: widget.direction,
                primaryColor: widget.primaryColor.darken(0.65),
                secondaryColor: widget.secondaryColor.darken(0.65),
                minSize: widget.minSize,
                maxSize: widget.maxSize,
              ),
              child: Container(),
            );
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildStack();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
