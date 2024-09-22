import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class EasyButton extends StatelessWidget {
  static VoidCallback? sfxOnPressed;

  // button stuff
  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final double borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets padding;
  final Color? color;
  final UIColor uiColor;
  final double? containerThickness;
  final bool interactable;

  // contents
  final Widget? child;

  EasyButton({
    super.key,
    this.onPressed,
    this.width,
    this.height,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.color,
    this.uiColor = UIColor.blue,
    this.borderRadius = 20,
    this.containerThickness,
    this.interactable = true,
    Widget? child,
    String? text,
    TextStyle? textStyle,
    Widget? icon,
    IconData? iconData,
    double? fontSize,
  }) : child = _resolveChildWidget(
          child: child,
          text: text,
          textStyle: textStyle,
          icon: icon,
          iconData: iconData,
          fontSize: fontSize,
        );

  static Widget? _resolveChildWidget({
    required Widget? child,
    required String? text,
    required TextStyle? textStyle,
    required Widget? icon,
    required IconData? iconData,
    required double? fontSize,
  }) {
    if (child != null) {
      return child;
    }

    Widget? iconWidget = _resolveIcon(icon: icon, iconData: iconData);
    if (iconWidget != null && text != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconWidget,
          const SizedBox(width: 8),
          _resolveTextWidget(text, textStyle, fontSize),
        ],
      );
    } else if (text != null) {
      return _resolveTextWidget(text, textStyle, fontSize);
    } else if (iconWidget != null) {
      return iconWidget;
    } else {
      return null;
    }
  }

  static Widget? _resolveIcon({
    required Widget? icon,
    required IconData? iconData,
  }) {
    if (icon != null) {
      return icon;
    } else if (iconData != null) {
      return Icon(iconData);
    }
    return null;
  }

  static Widget _resolveTextWidget(
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

  void _press() {
    if (interactable) {
      sfxOnPressed?.call();
      onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _press,
      child: EasyContainer(
        width: width,
        height: height,
        borderRadius: borderRadius,
        margin: margin,
        padding: padding,
        color: color,
        uiColor: interactable ? uiColor : UIColor.grey,
        borderDirection: BorderDirection.none,
        containerThickness: containerThickness ?? 3,
        child: child,
      ),
    );
  }
}
