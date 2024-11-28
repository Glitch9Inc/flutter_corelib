import 'package:flutter/material.dart';
import 'package:flutter_corelib/ui/utils/painters/pattern_painter.dart';
import 'package:flutter_corelib/ui/models/enum/widget_direction.dart';
import 'package:flutter_corelib/ui/utils/static/image_util.dart';
import 'dart:ui' as ui;

class PanPatternBackground extends StatefulWidget {
  final List<String> iconImagePaths;

  final Color? iconColor;
  final Color? backgroundColor;
  final double iconSize;
  final double spacing;
  final double rotationAngle;
  final double speed;
  final HorizontalDirection direction;

  const PanPatternBackground({
    super.key,
    required this.iconImagePaths,
    this.iconSize = 40,
    this.spacing = 20,
    this.rotationAngle = 0,
    this.iconColor,
    this.speed = 1, // 커질수록 빨라짐
    this.direction = HorizontalDirection.left,
    this.backgroundColor,
  });

  @override
  State<PanPatternBackground> createState() => _PanPatternBackgroundState();
}

class _PanPatternBackgroundState extends State<PanPatternBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _calculateSpeed()), // Dynamic duration based on speed
    )..repeat(); // Repeats indefinitely
  }

  int _calculateSpeed() {
    // speed 1 is duration 10 * number of images
    // speed 2 is duration 5 * number of images
    // speed 3 is duration 3.33 * number of images
    return (5 / widget.speed * widget.iconImagePaths.length).ceil();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<ui.Image>> _loadImages() async {
    final images = await Future.wait(widget.iconImagePaths.map((path) => ImageUtil.loadImage(path)).toList());
    return images;
  }

  double _calculateOffsetX() {
    double directionMultiplier = widget.direction == HorizontalDirection.right ? -1 : 1;
    int imageCount = widget.iconImagePaths.length;

    return -_controller.value * (widget.iconSize + widget.spacing) * (imageCount * directionMultiplier);
  }

  Widget _buildFutureBuilder() {
    return FutureBuilder<List<ui.Image>>(
      future: _loadImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading images'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No images found'));
        } else {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: PatternPainter(
                  images: snapshot.data!,
                  iconSize: widget.iconSize,
                  spacing: widget.spacing,
                  rotationAngle: widget.rotationAngle,
                  iconColor: widget.iconColor,
                  offsetX: _calculateOffsetX(),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.backgroundColor != null) Container(color: widget.backgroundColor),
        _buildFutureBuilder(),
      ],
    );
  }
}
