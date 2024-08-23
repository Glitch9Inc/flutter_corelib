import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart' hide TextDirection;

enum StrokeStyle {
  solid,
  blurred,
}

class StrokeText extends StatelessWidget {
  final String text;
  final double? strokeWidth;
  final Color textColor;
  final Color? strokeColor;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextOverflow? overflow;
  final int? maxLines;
  final double minFontSize;
  final StrokeStyle strokeStyle;

  const StrokeText(
    this.text, {
    super.key,
    this.strokeWidth,
    this.strokeColor,
    this.textColor = Colors.white,
    this.style,
    this.textAlign,
    this.textDirection,
    this.overflow,
    this.maxLines,
    this.minFontSize = 12,
    this.strokeStyle = StrokeStyle.solid,
  });

  double _resolveStrokeWidth() {
    if (strokeWidth != null) return strokeWidth!;
    if (style != null) return style!.fontSize! / 6;
    return 3;
  }

  TextStyle _borderStyle() {
    return TextStyle(
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _resolveStrokeWidth()
        ..color = strokeColor ?? Get.theme.colorScheme.surfaceBright,
    );
  }

  Shadow _blurredShadow() {
    return Shadow(
      color: strokeColor ?? Get.theme.colorScheme.surfaceBright,
      offset: const Offset(0, 0),
      blurRadius: _resolveStrokeWidth() * 4,
    );
  }

  TextStyle _mergeStyle() {
    if (strokeStyle == StrokeStyle.solid) {
      return TextStyle(
        fontSize: style!.fontSize,
        fontWeight: style!.fontWeight,
        fontStyle: style!.fontStyle,
        letterSpacing: style!.letterSpacing,
        wordSpacing: style!.wordSpacing,
        height: style!.height,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = _resolveStrokeWidth()
          ..color = strokeColor ?? Get.theme.colorScheme.surfaceBright,
      );
    } else {
      return TextStyle(
        fontSize: style!.fontSize,
        fontWeight: style!.fontWeight,
        fontStyle: style!.fontStyle,
        letterSpacing: style!.letterSpacing,
        wordSpacing: style!.wordSpacing,
        height: style!.height,
        shadows: [
          _blurredShadow(),
          _blurredShadow(),
        ],
      );
    }
  }

  TextStyle _foregroundStyle() {
    TextStyle nonNullStyle = style ?? Get.textTheme.bodyMedium!.copyWith(color: textColor);
    return TextStyle(
      fontSize: nonNullStyle.fontSize,
      fontWeight: nonNullStyle.fontWeight,
      fontStyle: nonNullStyle.fontStyle,
      letterSpacing: nonNullStyle.letterSpacing,
      wordSpacing: nonNullStyle.wordSpacing,
      height: nonNullStyle.height,
      color: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AutoSizeText(
          text,
          style: style == null ? _borderStyle() : _mergeStyle(),
          textAlign: textAlign,
          textDirection: textDirection,
          overflow: overflow,
          maxLines: maxLines,
          minFontSize: minFontSize,
        ),
        AutoSizeText(
          text,
          style: _foregroundStyle(),
          textDirection: textDirection,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          minFontSize: minFontSize,
        ),
      ],
    );
  }
}
