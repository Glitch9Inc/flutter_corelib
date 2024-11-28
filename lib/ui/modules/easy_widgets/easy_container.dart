import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class EasyContainer extends StatelessWidget {
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
  final MaterialColor? color;
  final double opacity;

  // decoration
  final double highlightWidth;
  final double thickness;
  final double borderRadius;
  final Gradient? gradient;
  final BorderDirection borderDirection;
  final bool noShadow;
  final bool noPattern;
  final bool noGradient;
  final bool noSideHighlight;
  final String? customPattern;

  const EasyContainer({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.transform,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.none,
    this.opacity = 1,
    this.color,
    this.borderRadius = 20,
    this.highlightWidth = 1,
    this.borderDirection = BorderDirection.all,
    this.thickness = 2.5,
    this.gradient,
    this.child,
    this.noShadow = false,
    this.noPattern = false,
    this.noGradient = false,
    this.noSideHighlight = false,
    this.customPattern,
  });

  DecorationImage? _resolvePattern(Color filterColor) {
    if (noPattern) return null;
    return DecorationImage(
      image: AssetImage(customPattern ?? 'assets/images/patterns/btn_pattern.png'),
      fit: BoxFit.cover,
      //colorFilter: ColorFilter.mode(filterColor, BlendMode.srcATop),
      colorFilter: ColorFilter.mode(filterColor, BlendMode.modulate),
    );
  }

  Gradient? _resolveGradient(Color lightColor, Color darkColor) {
    if (noGradient) return null;
    if (gradient != null) return gradient;

    return LinearGradient(
      colors: [
        lightColor.withOpacity(opacity),
        darkColor.withOpacity(opacity),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  Color? _resolveColor(MaterialColor materialColor) {
    if (!noGradient) return null;
    return materialColor[500]!.withOpacity(opacity);
  }

  BoxShadow _getThickness(Color color) {
    return BoxShadow(
      color: color,
      offset: Offset(0, thickness),
    );
  }

  BoxShadow _getCastShadow(
    Color color, [
    double radius = 3,
    double opacity = 0.5,
  ]) {
    return BoxShadow(
      color: Colors.black.withOpacity(opacity),
      spreadRadius: 1,
      blurRadius: 1,
      offset: Offset(0, radius * 1.5),
    );
  }

  BorderSide _highlight(Color color) {
    return BorderSide(
      color: color,
      width: highlightWidth,
      //strokeAlign: BorderSide.strokeAlignOutside,
    );
  }

  Border _createHighlightBorder(Color color) {
    if (noSideHighlight) {
      return Border(top: _highlight(color));
    }
    return Border(
      top: _highlight(color),
      left: _highlight(color),
      right: _highlight(color),
    );
  }

  BoxDecoration _resolveDecoration() {
    const highlightSaturation = 0.2;
    final materialColor = color ?? WidgetColor.blue;

    final highlightColor = materialColor[100]!.saturate(highlightSaturation);
    final lightColor = materialColor[300]!;
    final darkColor = materialColor[500]!;
    final filterColor = materialColor[500]!;
    final thicknessColor = materialColor[700]!;
    final shadowColor = materialColor[900]!;

    return BoxDecoration(
      image: _resolvePattern(filterColor),
      borderRadius: borderDirection.resolveBorderRadius(borderRadius),
      border: _createHighlightBorder(highlightColor),
      color: _resolveColor(materialColor),
      gradient: _resolveGradient(lightColor, darkColor),
      boxShadow: [
        if (!noShadow) _getCastShadow(shadowColor),
        if (thickness > 0) _getThickness(thicknessColor),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      clipBehavior: clipBehavior,
      transform: transform,
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: _resolveDecoration(),
      child: child,
    );
  }
}
