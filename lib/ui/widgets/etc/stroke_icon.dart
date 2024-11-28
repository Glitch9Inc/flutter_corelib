import 'package:flutter/material.dart';

class StrokeIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final double strokeWidth;

  const StrokeIcon(
    this.icon, {
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outline icon
        Icon(
          icon,
          size: size,
          color: Colors.black,
        ),
        // Filled icon
        Icon(
          icon,
          size: size - strokeWidth,
          color: color ?? Colors.white,
        ),
      ],
    );
  }
}
