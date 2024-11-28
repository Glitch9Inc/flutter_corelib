import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_corelib/ui/utils/painters/pattern_painter.dart';
import 'package:flutter_corelib/ui/utils/static/image_util.dart';

class PatternBackground extends StatefulWidget {
  final List<String> iconImagePaths;
  final Color? iconColor;
  final double iconSize;
  final double spacing;
  final double rotationAngle;

  const PatternBackground({
    super.key,
    required this.iconImagePaths,
    this.iconSize = 40,
    this.spacing = 20,
    this.rotationAngle = 0,
    this.iconColor,
  });

  @override
  State<PatternBackground> createState() => _PatternBackgroundState();
}

class _PatternBackgroundState extends State<PatternBackground> {
  late Future<List<ui.Image>> _imagesFuture;

  @override
  void initState() {
    super.initState();
    _imagesFuture = _loadImages();
  }

  Future<List<ui.Image>> _loadImages() async {
    return await Future.wait(widget.iconImagePaths.map(ImageUtil.loadImage).toList());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ui.Image>>(
      future: _imagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink(); // Empty widget instead of an error message
        } else {
          return RepaintBoundary(
            child: CustomPaint(
              size: Size.infinite,
              painter: PatternPainter(
                images: snapshot.data!,
                iconSize: widget.iconSize,
                spacing: widget.spacing,
                rotationAngle: widget.rotationAngle,
                iconColor: widget.iconColor,
              ),
            ),
          );
        }
      },
    );
  }
}
