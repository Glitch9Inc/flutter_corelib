import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart' hide TextDirection;

export 'stroke_type.dart';
export 'stroke_style.dart';

class StrokeText extends StatelessWidget {
  final String text;

  // 기본 폰트 설정
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double minFontSize;

  // 추가 설정
  final StrokeStyle? strokeStyle;
  final TextDirection? textDirection;
  final Color fontColor;

  const StrokeText(
    this.text, {
    super.key,
    this.fontColor = Colors.white,
    this.style,
    this.textAlign,
    this.textDirection,
    StrokeStyle? strokeStyle,
    this.overflow,
    this.maxLines,
    this.minFontSize = 12,
  }) : strokeStyle = strokeStyle ?? const StrokeStyle();

  Color _resolveStrokeColor() {
    if (strokeStyle!.color != null) return strokeStyle!.color!;
    if (strokeStyle!.type == StrokeType.outline) return Colors.black;
    return Colors.black.withOpacity(0.5);
  }

  double _resolveStrokeWidth() {
    if (strokeStyle!.width != null) return strokeStyle!.width!;
    if (style != null) return style!.fontSize! / 5;
    return 3;
  }

  TextStyle _borderStyle() {
    return TextStyle(
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _resolveStrokeWidth()
        ..color = _resolveStrokeColor(),
    );
  }

  Shadow _blurredShadow() {
    return Shadow(
      color: _resolveStrokeColor(),
      offset: const Offset(0, 0),
      blurRadius: _resolveStrokeWidth() * 4,
    );
  }

  TextStyle _mergeStyle() {
    if (strokeStyle!.type == StrokeType.outline) {
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
            ..color = _resolveStrokeColor()
            ..strokeJoin = StrokeJoin.round // 모서리를 매끄럽게 처리
          );
    } else {
      return TextStyle(
        fontSize: style!.fontSize,
        fontWeight: style!.fontWeight,
        fontStyle: style!.fontStyle,
        letterSpacing: style!.letterSpacing,
        wordSpacing: style!.wordSpacing,
        height: style!.height,
        shadows: List.generate(strokeStyle!.intensity, (index) => _blurredShadow()),
      );
    }
  }

  TextStyle _foregroundStyle() {
    TextStyle nonNullStyle = style ?? Get.textTheme.bodyMedium!.copyWith(color: fontColor);
    return TextStyle(
      fontSize: nonNullStyle.fontSize,
      fontWeight: nonNullStyle.fontWeight,
      fontStyle: nonNullStyle.fontStyle,
      letterSpacing: nonNullStyle.letterSpacing,
      wordSpacing: nonNullStyle.wordSpacing,
      height: nonNullStyle.height,
      color: fontColor,
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
