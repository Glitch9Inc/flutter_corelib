import 'package:flutter/material.dart';

class GrayScale extends StatelessWidget {
  final Widget child;
  final bool isOn;

  const GrayScale({super.key, required this.child, this.isOn = true});

  @override
  Widget build(BuildContext context) {
    if (!isOn) return child;
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(
        <double>[
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
        ],
      ),
      child: child,
    );
  }
}
