import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

import 'easy_widget_util.dart';

class EasyButton extends StatelessWidget {
  static VoidCallback? sfxOnPressed;

  // basic properties
  final double? width;
  final double height;
  final EdgeInsets? margin;
  final EdgeInsets padding;
  final AlignmentGeometry alignment;

  // color properties
  final Color? color;
  final UIColor? uiColor;

  // decoration properties
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final Gradient? gradient;
  final BoxBorder? border;
  final BorderDirection? borderDirection;
  final double? thickness;
  final bool noShadow;

  // button properties
  final VoidCallback? onPressed;
  final bool interactable;
  final bool noPattern;

  EasyButton({
    super.key,
    this.onPressed,
    this.interactable = true,
    this.width,
    this.height = 48,
    this.alignment = Alignment.center,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.color,
    this.uiColor,
    this.border,
    this.borderRadius = 20,
    this.borderWidth = 1,
    this.borderColor,
    this.borderDirection,
    this.gradient,
    this.thickness,
    this.noShadow = false,
    this.noPattern = false,
    String? text,
    double? fontSize,
    TextStyle? textStyle,
    Widget? icon,
    double? iconSize,
    IconData? iconData,
    Widget? child,
  }) : _child = EasyWidgetUtil.resolveChild(
          child: child,
          text: text,
          textStyle: textStyle,
          icon: icon,
          iconData: iconData,
          fontSize: fontSize,
          iconSize: iconSize,
        );

  factory EasyButton.small({
    VoidCallback? onPressed,
    bool interactable = true,
    double height = 34,
    double? width,
    AlignmentGeometry alignment = Alignment.center,
    EdgeInsets? margin,
    Color? color,
    UIColor? uiColor,
    Border? border,
    double borderWidth = 1,
    Color? borderColor,
    BorderDirection? borderDirection,
    Gradient? gradient,
    double? thickness,
    bool noShadow = false,
    String? text,
    Widget? icon,
    double? iconSize,
    IconData? iconData,
    Widget? child,
  }) {
    return EasyButton(
      onPressed: onPressed,
      interactable: interactable,
      width: width,
      height: height,
      alignment: alignment,
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: color,
      uiColor: uiColor,
      border: border,
      noPattern: true,
      borderRadius: 12,
      borderWidth: borderWidth,
      borderColor: borderColor,
      borderDirection: borderDirection,
      gradient: gradient,
      thickness: thickness,
      noShadow: noShadow,
      text: text,
      textStyle: Get.textTheme.bodySmall!.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      icon: icon,
      iconSize: iconSize,
      iconData: iconData,
      child: child,
    );
  }

  final Widget? _child;

  void _onTap() {
    if (interactable) {
      sfxOnPressed?.call();
      onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final finalUiColor = interactable ? uiColor ?? UIColor.blue : UIColor.darkGrey;
    final finalBorder = EasyWidgetUtil.resolveBorder(
      border: border,
      borderColor: borderColor ?? EasyContainer.defaultBorderColor,
      borderWidth: borderWidth,
      borderDirection: borderDirection,
      finalUIColor: finalUiColor.color[200]!,
    );

    return IntrinsicWidth(
      // 자식의 크기에 맞게 너비가 조정되도록 IntrinsicWidth 사용
      child: AnimatedGestureDetector(
        height: height,
        width: width ?? double.infinity,
        onTap: _onTap,
        child: EasyContainer(
          height: height,
          width: width,
          alignment: alignment,
          borderRadius: borderRadius,
          margin: margin,
          padding: padding,
          color: color,
          uiColor: finalUiColor,
          border: finalBorder,
          gradient: gradient,
          thickness: thickness ?? 2,
          noShadow: noShadow,
          noPattern: noPattern,
          child: Opacity(opacity: interactable ? 1 : 0.5, child: _child),
        ),
      ),
    );
  }
}
