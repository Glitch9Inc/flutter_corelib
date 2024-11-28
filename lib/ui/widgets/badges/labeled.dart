import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class Labeled extends StatelessWidget {
  const Labeled({
    super.key,
    required this.label,
    required this.child,
    this.bottomOffset = 2.5,
    this.childBottomOffset,
    this.textStyle,
    this.strokeStyle,
    this.maxLines = 1,
  });

  final String label;
  final Widget child;
  final double bottomOffset;
  final double? childBottomOffset;
  final TextStyle? textStyle;
  final StrokeStyle? strokeStyle;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        if (childBottomOffset != null)
          Positioned(
            bottom: childBottomOffset,
            child: child,
          )
        else
          child,
        Positioned(
          bottom: bottomOffset,
          child: StrokeText(
            label,
            style: textStyle ?? Get.textTheme.bodyMedium!.copyWith(height: 1),
            strokeStyle: strokeStyle,
            textAlign: TextAlign.center,
            maxLines: maxLines,
            minFontSize: 10,
          ),
        ),
      ],
    );
  }
}
