import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class SliderThumb extends StatelessWidget {
  final double radius;
  final Decoration? decoration;

  const SliderThumb({
    super.key,
    required this.radius,
    this.decoration,
  });

  factory SliderThumb.basic() {
    return const SliderThumb(
      radius: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: decoration ??
          BoxDecoration(
            shape: BoxShape.circle,
            color: Get.theme.colorScheme.onPrimary,
          ),
    );
  }
}
