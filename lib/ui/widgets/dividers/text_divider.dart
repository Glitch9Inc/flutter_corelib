import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

enum TextPosition {
  start,
  center,
  end,
}

class TextDivider extends StatelessWidget {
  final String text;
  final Widget? icon;
  final TextStyle? textStyle;
  final double thickness;
  final Color color;
  final TextPosition textPosition;
  final int textPositionFlex;
  final double horizontalPadding;

  const TextDivider({
    super.key,
    required this.text,
    this.icon,
    this.textStyle,
    this.thickness = 1.0,
    this.color = Colors.white70,
    this.textPosition = TextPosition.center,
    this.textPositionFlex = 15,
    this.horizontalPadding = 0.0,
  });

  Widget _text() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(width: 4),
        ],
        Text(
          text,
          style: textStyle ?? Get.textTheme.bodyMedium!.copyWith(color: color),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: horizontalPadding),
        if (textPosition == TextPosition.start) ...[
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: Divider(
              thickness: thickness,
              color: color,
            ),
          ),
          _text(),
        ],
        if (textPosition == TextPosition.center) ...[
          Flexible(
            fit: FlexFit.loose,
            flex: textPositionFlex,
            child: Divider(
              thickness: thickness,
              color: color,
            ),
          ),
          _text(),
          Flexible(
            fit: FlexFit.loose,
            flex: textPositionFlex,
            child: Divider(
              thickness: thickness,
              color: color,
            ),
          ),
        ] else if (textPosition == TextPosition.end) ...[
          _text(),
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: Divider(
              thickness: thickness,
              color: color,
            ),
          ),
        ] else ...[
          Flexible(
            fit: FlexFit.loose,
            flex: textPositionFlex,
            child: Divider(
              thickness: thickness,
              color: color,
            ),
          ),
        ],
        SizedBox(width: horizontalPadding),
      ],
    );
  }
}
