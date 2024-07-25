import 'package:flutter/material.dart';

class SwollenClipper extends CustomClipper<Path> {
  final double swell;
  const SwollenClipper(this.swell);

  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from bottom-left corner
    path.moveTo(0, size.height);

    // Draw a line to the top-left corner
    path.lineTo(0, size.height / 2);

    // Draw a quadratic curve to the top-right corner
    path.quadraticBezierTo(
        size.width / 2,
        size.height / 2 - swell, // Control point
        size.width,
        size.height / 2 // End point
        );

    // Draw a line to the bottom-right corner
    path.lineTo(size.width, size.height);

    // Close the path to the starting point
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
