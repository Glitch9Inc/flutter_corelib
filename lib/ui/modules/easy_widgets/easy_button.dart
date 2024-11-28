import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

import 'easy_util.dart';

enum IconPosition {
  left,
  right,
}

class EasyButton extends StatelessWidget {
  static VoidCallback? sfxOnPressed;

  // basic properties
  final double? width;
  final double height;
  final EdgeInsets? margin;
  final EdgeInsets padding;
  final AlignmentGeometry alignment;
  final Widget? child;

  // color properties
  final MaterialColor? color;
  final MaterialColor? nonInteractableColor;
  final double opacity;

  // decoration properties
  final double borderRadius;
  final double highlightWidth;

  final Gradient? gradient;

  final BorderDirection borderDirection;
  final double thickness;
  final bool noShadow;

  // button properties
  final VoidCallback? onPressed;
  final bool interactable;
  final String? customPattern;
  final bool noPattern;

  EasyButton({
    super.key,
    this.onPressed,
    this.interactable = true,
    this.width,
    this.height = 44,
    this.alignment = Alignment.center,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.color,
    this.nonInteractableColor,
    this.opacity = 1,
    this.borderRadius = 20,
    this.highlightWidth = 1,
    this.borderDirection = BorderDirection.all,
    this.gradient,
    this.thickness = 2.5,
    this.noShadow = false,
    this.customPattern,
    this.noPattern = false,
    String? text,
    double? fontSize,
    TextStyle? textStyle,
    Widget? icon,
    double? iconSize,
    String? iconPath,
    double iconSpacing = 8,
    IconData? iconData,
    IconPosition iconPosition = IconPosition.left,
    Widget? child,
  }) : child = EasyUtil.resolveChild(
          child: child,
          text: text,
          textStyle: textStyle,
          icon: icon,
          iconPath: iconPath,
          iconData: iconData,
          fontSize: fontSize,
          iconSize: iconSize,
          iconSpacing: iconSpacing,
          iconPosition: iconPosition,
        );

  void _onTap() {
    if (interactable) {
      sfxOnPressed?.call();
      onPressed?.call();
    }
  }

  Widget _buildEasyContainer() {
    return EasyContainer(
      clipBehavior: Clip.antiAlias,
      height: height,
      width: width,
      alignment: alignment,
      borderRadius: borderRadius,
      borderDirection: borderDirection,
      margin: margin,
      padding: padding,
      color: interactable ? color : nonInteractableColor ?? WidgetColor.grey,
      opacity: opacity,
      gradient: gradient,
      thickness: thickness,
      noShadow: noShadow,
      noPattern: noPattern,
      customPattern: customPattern,
      child: Opacity(opacity: interactable ? 1 : 0.5, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (onPressed == null) {
      return _buildEasyContainer();
    } else {
      return AnimatedGestureDetector(
        onTap: _onTap,
        child: _buildEasyContainer(),
      );
    }
  }
}
