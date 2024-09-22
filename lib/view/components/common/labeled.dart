import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class Labeled extends StatelessWidget {
  const Labeled({
    super.key,
    required this.label,
    required this.child,
    this.bottomOffset = 2.5,
    this.textStyle,
    this.strokeStyle,
  });

  final String label;
  final Widget child;
  final double bottomOffset;
  final TextStyle? textStyle;
  final StrokeStyle? strokeStyle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          bottom: 2.5,
          child: StrokeText(
            label,
            style: textStyle ??
                Get.textTheme.bodyMedium!.copyWith(
                  height: 1,
                ),
            strokeStyle: strokeStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
