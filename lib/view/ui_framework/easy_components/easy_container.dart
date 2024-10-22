import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class EasyContainer extends StatelessWidget {
  static const Color defaultBorderColor = routinaCharcoalW900;

  // 기본
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Widget? child;
  final Clip clipBehavior;
  final Matrix4? transform;
  final AlignmentGeometry alignment;

  // 색상
  final Color? color;
  final UIColor uiColor;

  // decoration
  final double thickness;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final Gradient? gradient;
  final BoxBorder? border;
  final BorderDirection? borderDirection;
  final bool noShadow;
  final bool noPattern;

  const EasyContainer({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.transform,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.none,
    this.color,
    this.uiColor = UIColor.blue,
    this.borderRadius = 20,
    this.borderWidth = 1,
    this.borderColor,
    this.borderDirection,
    this.thickness = 2,
    this.gradient,
    this.border,
    this.child,
    this.noShadow = false,
    this.noPattern = false,
  });

  BoxDecoration _resolveDecoration() {
    // topColor is the main color which is darker than botColor
    final topColor = color ?? uiColor.color[300]!;

    // botColor is the color which is brighter than topColor
    final botColor = color != null ? color!.brighten(0.1) : uiColor.color[600]!.saturate(0.2);

    final filterColor = color != null ? color!.darken(0.1) : uiColor.color[700]!;

    final finalBorderColor = borderColor ?? defaultBorderColor;

    final finalBorderRadius = borderDirection == null
        ? BorderRadius.circular(borderRadius)
        : borderDirection!.resolveBorderRadius(borderRadius);

    final finalBorder = border ?? borderDirection?.resolveBorder(finalBorderColor, borderWidth);

    final finalGradient = gradient ??
        LinearGradient(
          colors: [
            topColor,
            botColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

    return BoxDecoration(
      image: noPattern
          ? null
          : DecorationImage(
              image: const AssetImage('assets/images/btn_pattern.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(filterColor, BlendMode.srcATop),
            ),
      borderRadius: finalBorderRadius,
      border: finalBorder,
      gradient: finalGradient,
      boxShadow: getCartoonBoxShadow(color: finalBorderColor, thickness: thickness, noShadow: noShadow),
    );
  }

  @override
  Widget build(BuildContext context) {
    final decoration = _resolveDecoration();

    return Container(
      alignment: alignment,
      clipBehavior: clipBehavior,
      transform: transform,
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: child,
    );
  }
}
