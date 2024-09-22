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

  const TextDivider({
    super.key,
    required this.text,
    this.icon,
    this.textStyle,
    this.thickness = 1.0,
    this.color = Colors.grey,
    this.textPosition = TextPosition.center,
    this.textPositionFlex = 15,
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
          style: textStyle ?? Get.textTheme.bodyMedium,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (textPosition == TextPosition.start) ...[
          Expanded(
            flex: 1,
            child: Divider(
              thickness: thickness,
              color: color,
            ),
          ),
          _text(),
        ],
        Expanded(
          flex: textPositionFlex,
          child: Divider(
            thickness: thickness,
            color: color,
          ),
        ),
        if (textPosition == TextPosition.center) _text(),
        Expanded(
          flex: textPositionFlex,
          child: Divider(
            thickness: thickness,
            color: color,
          ),
        ),
        if (textPosition == TextPosition.end) ...[
          _text(),
          Expanded(
            flex: 1,
            child: Divider(
              thickness: thickness,
              color: color,
            ),
          ),
        ],
      ],
    );
  }
}
