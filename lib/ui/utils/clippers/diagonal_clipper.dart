import 'package:flutter/material.dart';

class DiagonalClipper extends CustomClipper<Path> {
  final double angle; // Angle for the diagonal

  DiagonalClipper({this.angle = 0.25}); // Default angle to 0.25 (25%)

  @override
  Path getClip(Size size) {
    Path path = Path();

    // Calculate the vertical offset based on the provided angle
    double verticalOffset = 600 * angle;

    path.lineTo(0, verticalOffset); // Start at the calculated vertical offset
    path.lineTo(size.width, 0); // Draw a line to the top right corner
    path.lineTo(size.width, size.height); // Draw a line to the bottom right corner
    path.lineTo(0, size.height); // Draw a line to the bottom left corner
    path.close(); // Close the path to form a rectangle with a diagonal cut
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return oldClipper is DiagonalClipper && oldClipper.angle != angle;
  }
}
