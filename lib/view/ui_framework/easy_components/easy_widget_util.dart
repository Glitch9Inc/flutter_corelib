import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

abstract class EasyWidgetUtil {
  static Widget? resolveChild({
    required Widget? child,
    required String? text,
    required TextStyle? textStyle,
    required Widget? icon,
    required IconData? iconData,
    required double? fontSize,
    required double? iconSize,
  }) {
    if (child != null) {
      return child;
    }

    Widget? iconWidget = _resolveIcon(icon: icon, iconData: iconData, iconSize: iconSize);
    if (iconWidget != null && text != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconWidget,
          const SizedBox(width: 8),
          _resolveText(text, textStyle, fontSize),
        ],
      );
    } else if (text != null) {
      return _resolveText(text, textStyle, fontSize);
    } else if (iconWidget != null) {
      return iconWidget;
    } else {
      return null;
    }
  }

  static BoxBorder? resolveBorder({
    required BoxBorder? border,
    required Color? borderColor,
    required double borderWidth,
    required BorderDirection? borderDirection,
    required Color finalUIColor,
  }) {
    if (border != null) {
      return border;
    }

    if (borderDirection == null) {
      //return BorderDirection.top.resolveBorder(borderColor ?? finalUIColor, borderWidth, false);
      return Border.all(width: borderWidth, color: borderColor ?? finalUIColor);
    }

    return borderDirection.resolveBorder(borderColor ?? finalUIColor, borderWidth);
  }

  static Widget? _resolveIcon({
    required Widget? icon,
    required IconData? iconData,
    required double? iconSize,
  }) {
    if (icon != null) {
      return icon;
    } else if (iconData != null) {
      return Center(child: Icon(iconData, size: iconSize ?? 24));
    }
    return null;
  }

  static Widget _resolveText(
    String text,
    TextStyle? textStyle,
    double? fontSize,
  ) {
    return Text(
      text,
      style: textStyle ??
          Get.textTheme.bodyLarge!.copyWith(
            fontSize: fontSize ?? 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
