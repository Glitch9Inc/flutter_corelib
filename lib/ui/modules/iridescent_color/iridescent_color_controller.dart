import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class IridescentColorController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  final colors = <Color>[
    const Color(0xFF42A5F5), // Blue
    const Color.fromARGB(255, 96, 237, 206), // Green
    const Color.fromARGB(255, 255, 40, 244), // Yellow
    const Color.fromARGB(255, 12, 206, 255), // Red
  ];

  final stops = <double>[
    0.0,
    0.33,
    0.66,
    1.0,
  ];

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
  }

  GradientTransform gradientTransform() {
    return GradientRotation(animationController.value * 2 * 3.14);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
