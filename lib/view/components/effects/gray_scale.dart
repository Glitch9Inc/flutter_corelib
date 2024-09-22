import 'package:flutter/material.dart';

class GrayScale extends StatelessWidget {
  final Widget child;
  final bool isOn;
  final double brightness; // 밝기 조절 값

  const GrayScale({
    super.key,
    required this.child,
    this.isOn = true,
    this.brightness = 1.0, // 기본 밝기값은 1.0
  });

  @override
  Widget build(BuildContext context) {
    if (!isOn) return child;

    // 밝기 조절 행렬
    final brightnessAdjustment = brightness.clamp(0.0, 2.0); // 0.0은 가장 어둡고, 2.0은 두 배 밝음

    return ColorFiltered(
      colorFilter: ColorFilter.matrix(
        <double>[
          0.2126 * brightnessAdjustment,
          0.7152 * brightnessAdjustment,
          0.0722 * brightnessAdjustment,
          0,
          0,
          0.2126 * brightnessAdjustment,
          0.7152 * brightnessAdjustment,
          0.0722 * brightnessAdjustment,
          0,
          0,
          0.2126 * brightnessAdjustment,
          0.7152 * brightnessAdjustment,
          0.0722 * brightnessAdjustment,
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
