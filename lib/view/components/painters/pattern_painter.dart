import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PatternPainter extends CustomPainter {
  final List<ui.Image> images;
  final Color? iconColor;
  final double iconSize;
  final double spacing;
  final double rotationAngle;
  final double offsetX;

  PatternPainter({
    required this.images,
    this.iconColor = Colors.black,
    this.iconSize = 40,
    this.spacing = 20,
    this.rotationAngle = 0,
    this.offsetX = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Apply rotation to the entire canvas
    canvas.save();

    // canvas 사이즈를 좌우로 늘린다
    double width = size.width * 2.5;
    double height = size.height * 2.5;

    canvas.translate(width / 2, height / 2);
    canvas.rotate(rotationAngle * (3.1415927 / 180));
    canvas.translate(-width / 2, -height / 2);

    final Paint paint = Paint();
    if (iconColor != null) {
      paint.colorFilter = ColorFilter.mode(iconColor!, BlendMode.srcIn);
    }

    // Calculate the effective width of one tile
    final tileWidth = iconSize + spacing;

    int rowIndex = 0;
    for (double y = 0; y < height; y += tileWidth) {
      int imageIndex = rowIndex;

      // Ensure seamless wrapping by repeating the pattern twice
      for (double x = -tileWidth + offsetX; x < width + tileWidth; x += tileWidth) {
        final image = images[imageIndex % images.length];
        final rect = Rect.fromLTWH(x, y, iconSize, iconSize);
        final srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
        canvas.drawImageRect(image, srcRect, rect, paint);

        // Move to the next image in the list
        imageIndex++;
      }

      rowIndex++;
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
