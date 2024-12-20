import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:flutter_corelib/ui/utils/painters/diamond_painter.dart';

class PanDiamondBackground extends StatefulWidget {
  final Color color;
  final Color? backgroundColor;
  final double diamondHeight;
  final double diamondWidth;
  final BackgroundPanDirection direction;

  const PanDiamondBackground({
    super.key,
    required this.color,
    this.backgroundColor,
    this.direction = BackgroundPanDirection.toBottomLeft,
    this.diamondHeight = 100,
    this.diamondWidth = 100,
  });

  @override
  PanDiamondBackgroundState createState() => PanDiamondBackgroundState();
}

class PanDiamondBackgroundState extends State<PanDiamondBackground> with TickerProviderStateMixin {
  late AnimationController _panController;
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  late Color color;
  late Color backgroundColor;

  bool isLeaving = false;

  @override
  void initState() {
    super.initState();
    color = widget.color;
    backgroundColor = widget.backgroundColor ?? color.darken(0.1);

    _panController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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

  void stopAnimation() {
    // _panController.stop();
    // _colorController.stop();

    // // 애니메이션 위치를 초기화
    // _panController.value = 0;
    if (mounted) {
      setState(() {
        isLeaving = true;
      }); // 초기 위치로 되돌리기 위해 rebuild 호출
    }
  }

  @override
  void dispose() {
    _panController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void changeColors(Color primary, {Color? secondary}) {
    if (mounted) {
      secondary ??= primary.darken(0.1);

      _colorAnimation = ColorTween(begin: color, end: primary).animate(_colorController);
      _backgroundColorAnimation = ColorTween(begin: backgroundColor, end: secondary).animate(_colorController);

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
    if (isLeaving) {
      return Container(
        color: backgroundColor,
      );
    }
    return RepaintBoundary(
      child: Container(
        color: backgroundColor,
        child: AnimatedBuilder(
          animation: _panController,
          builder: (context, child) {
            final offset = _getOffset(_panController.value * 100);
            return Stack(
              children: [
                Transform.translate(
                  offset: offset,
                  child: child,
                ),
                Transform.translate(
                  offset: offset + const Offset(100, 0),
                  child: child,
                ),
                Transform.translate(
                  offset: offset + const Offset(0, 100),
                  child: child,
                ),
                Transform.translate(
                  offset: offset + const Offset(100, 100),
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
      ),
    );
  }
}
