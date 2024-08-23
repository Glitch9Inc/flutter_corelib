import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:flutter_corelib/view/painter/diamond_painter.dart';
import 'package:flutter_corelib/view/painter/heart_painter.dart';

class AnimatedDiamondBackground extends StatefulWidget {
  final Color color;
  final Color backgroundColor;
  final double diamondHeight;
  final double diamondWidth;
  final BackgroundPanDirection direction;

  const AnimatedDiamondBackground({
    super.key,
    required this.color,
    required this.backgroundColor,
    this.direction = BackgroundPanDirection.toBottomLeft,
    this.diamondHeight = 100,
    this.diamondWidth = 100,
  });

  @override
  AnimatedDiamondBackgroundState createState() => AnimatedDiamondBackgroundState();
}

class AnimatedDiamondBackgroundState extends State<AnimatedDiamondBackground> with TickerProviderStateMixin {
  late AnimationController _panController;
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  late Color color;
  late Color backgroundColor;

  @override
  void initState() {
    super.initState();
    color = widget.color;
    backgroundColor = widget.backgroundColor;

    _panController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _colorAnimation = ColorTween(begin: color, end: color).animate(_colorController);
    _backgroundColorAnimation = ColorTween(begin: backgroundColor, end: backgroundColor).animate(_colorController);

    _colorController.addListener(() {
      if (mounted) {
        setState(() {
          color = _colorAnimation.value!;
          backgroundColor = _backgroundColorAnimation.value!;
        });
      }
    });
  }

  @override
  void dispose() {
    _panController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void changeColors(Color newColor, Color newBackgroundColor) {
    if (mounted) {
      _colorAnimation = ColorTween(begin: color, end: newColor).animate(_colorController);
      _backgroundColorAnimation = ColorTween(begin: backgroundColor, end: newBackgroundColor).animate(_colorController);

      _colorController.reset();
      _colorController.forward();
    }
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
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
        animation: _panController,
        builder: (context, child) {
          return Stack(
            children: [
              for (double dx = -1.0; dx <= 1.0; dx++)
                for (double dy = -1.0; dy <= 1.0; dy++)
                  Transform.translate(
                    offset: _getOffset(_panController.value * 100) + Offset(dx * 100, dy * 100),
                    child: child,
                  ),
            ],
          );
        },
        child: CustomPaint(
          painter: DiamondPainter(
            color: color,
            shapeWidth: widget.diamondWidth,
            shapeHeight: widget.diamondHeight,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}
