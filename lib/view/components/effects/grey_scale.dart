import 'package:flutter/material.dart';

class GreyScale extends StatelessWidget {
  static const ColorFilter greyscale = ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  final Widget child;
  final double opacity;

  const GreyScale({super.key, required this.child, this.opacity = 1});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: greyscale,
      child: child,
    );
  }
}
