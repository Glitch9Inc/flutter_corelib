import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

abstract class EasyUtil {
  static Widget? resolveChild({
    required Widget? child,
    required String? text,
    required TextStyle? textStyle,
    required Widget? icon,
    required String? iconPath,
    required IconData? iconData,
    required double? fontSize,
    required double? iconSize,
    required double iconSpacing,
    required IconPosition iconPosition,
  }) {
    if (child != null) {
      return child;
    }

    Widget? iconWidget = _resolveIcon(
      icon: icon,
      iconPath: iconPath,
      iconData: iconData,
      iconSize: iconSize,
    );

    if (iconWidget != null && text != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconPosition == IconPosition.left) ...[
            iconWidget,
            SizedBox(width: iconSpacing),
          ],
          Expanded(
            child: _resolveText(text, textStyle, fontSize),
          ),
          if (iconPosition == IconPosition.right) ...[
            SizedBox(width: iconSpacing),
            iconWidget,
          ],
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
    required Color uiColor,
  }) {
    if (border != null) {
      return border;
    }

    if (borderDirection == null) {
      //return BorderDirection.top.resolveBorder(borderColor ?? finalUIColor, borderWidth, false);
      return Border.all(width: borderWidth, color: borderColor ?? uiColor);
    }

    return borderDirection.resolveBorder(borderColor ?? uiColor, borderWidth);
  }

  static Widget? _resolveIcon({
    required Widget? icon,
    required String? iconPath,
    required IconData? iconData,
    required double? iconSize,
  }) {
    if (icon != null) {
      return icon;
    } else if (iconData != null) {
      return Center(child: Icon(iconData, size: iconSize ?? 24));
    } else if (iconPath != null) {
      return Center(child: Image.asset(iconPath, width: iconSize ?? 24, height: iconSize ?? 24));
    }
    return null;
  }

  static Widget _resolveText(
    String text,
    TextStyle? textStyle,
    double? fontSize,
  ) {
    return AutoSizeText(
      text,
      style: textStyle ??
          Get.textTheme.bodyLarge!.copyWith(
            fontSize: fontSize ?? 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
      textAlign: TextAlign.center,
      minFontSize: 10,
    );
  }
}
