import 'package:flutter/material.dart';
import 'package:flutter_corelib/view/components/wrappers/stroke_text.dart';

class IconText extends StatelessWidget {
  final Widget? icon;
  final IconData? iconData;
  final String text;
  final TextStyle? style;
  final double? space;
  final double? iconSize;
  final Color? iconColor;
  final TextAlign? textAlign;
  final StrokeStyle? strokeStyle;
  final Color? strokeColor;
  final double? strokeWidth;

  const IconText(
    this.text, {
    super.key,
    this.icon,
    this.iconData,
    this.style,
    this.space,
    this.iconSize,
    this.iconColor,
    this.textAlign,
    this.strokeStyle,
    this.strokeColor,
    this.strokeWidth,
  }) : assert(icon != null || iconData != null);

  Widget _resolveIcon() {
    if (icon != null) {
      return icon!;
    } else {
      TextStyle textStyle = _getStyle();
      double? localIconSize = iconSize;
      if (localIconSize == null) {
        localIconSize = textStyle.fontSize ?? 14;
        localIconSize *= 1.2;
      }

      Color? localIconColor = iconColor;
      localIconColor ??= textStyle.color ?? Colors.black;

      return Icon(
        iconData,
        size: localIconSize,
        color: localIconColor,
      );
    }
  }

  TextStyle _getStyle() {
    if (style != null) {
      return style!;
    } else {
      return const TextStyle();
    }
  }

  double _resolveSpace() {
    if (space != null) {
      return space!;
    } else {
      double fontSize = _getStyle().fontSize ?? 14;
      return fontSize * 0.3;
    }
  }

  MainAxisAlignment _resolveMainAxisAlignment() {
    if (textAlign != null) {
      switch (textAlign!) {
        case TextAlign.left:
          return MainAxisAlignment.start;
        case TextAlign.right:
          return MainAxisAlignment.end;
        case TextAlign.center:
          return MainAxisAlignment.center;
        case TextAlign.justify:
          return MainAxisAlignment.spaceBetween;
        case TextAlign.start:
          return MainAxisAlignment.start;
        case TextAlign.end:
          return MainAxisAlignment.end;
      }
    }

    return MainAxisAlignment.start;
  }

  CrossAxisAlignment _resolveCrossAxisAlignment() {
    if (textAlign != null) {
      switch (textAlign!) {
        case TextAlign.left:
          return CrossAxisAlignment.start;
        case TextAlign.right:
          return CrossAxisAlignment.end;
        case TextAlign.center:
          return CrossAxisAlignment.center;
        case TextAlign.justify:
          return CrossAxisAlignment.stretch;
        case TextAlign.start:
          return CrossAxisAlignment.start;
        case TextAlign.end:
          return CrossAxisAlignment.end;
      }
    }

    return CrossAxisAlignment.center;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: _resolveMainAxisAlignment(),
      crossAxisAlignment: _resolveCrossAxisAlignment(),
      children: [
        _resolveIcon(),
        SizedBox(width: _resolveSpace()),
        StrokeText(
          text,
          style: style,
          strokeStyle: strokeStyle ?? StrokeStyle.solid,
          strokeColor: strokeColor,
          strokeWidth: strokeWidth,
        ),
      ],
    );
  }
}
