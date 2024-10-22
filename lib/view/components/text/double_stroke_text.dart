import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class DoubleStrokeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double minFontSize;
  final StrokeStyle? innerStrokeStyle;
  final StrokeStyle? outerStrokeStyle;
  final double strokeWidth;

  const DoubleStrokeText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.innerStrokeStyle,
    this.outerStrokeStyle,
    this.minFontSize = 12,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? Get.textTheme.bodyMedium!;
    final finalInnerStrokeStyle = innerStrokeStyle ?? StrokeStyle.defaultInner();
    final finalOuterStrokeStyle = outerStrokeStyle ?? StrokeStyle.defaultOuter();
    final outerStrokeWidth =
        (finalOuterStrokeStyle.width ?? strokeWidth) + (finalInnerStrokeStyle.width ?? strokeWidth);
    final outerStrokeColor = finalOuterStrokeStyle.color ?? Colors.black;
    final innerStrokeWidth = finalInnerStrokeStyle.width ?? strokeWidth;
    final innerStrokeColor = finalInnerStrokeStyle.color ?? Colors.white;

    return Stack(
      children: [
        // 외곽선(바깥쪽)
        Text(
          text,
          style: textStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = outerStrokeWidth
              ..color = outerStrokeColor, // 바깥쪽 외곽선 색상
          ),
        ),
        // 외곽선(안쪽)
        Text(
          text,
          style: textStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = innerStrokeWidth
              ..color = innerStrokeColor, // 안쪽 외곽선 색상
          ),
        ),
        // 본문 텍스트
        AutoSizeText(
          text,
          style: textStyle,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          minFontSize: minFontSize,
        ),
      ],
    );
  }
}
