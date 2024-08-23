import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class HalftoneGradientContainer extends StatelessWidget {
  final HalftoneGradient gradient;
  final double? height;
  final double? width;

  final Color backgroundColor;
  final Decoration? decoration;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Widget? child;
  final BoxConstraints? constraints;

  const HalftoneGradientContainer({
    super.key,
    this.backgroundColor = Colors.transparent,
    this.height,
    this.width,
    this.child,
    this.decoration,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.constraints,
    this.gradient = const HalftoneGradient(
      type: HalftoneType.circle,
      color: Colors.white,
      halftoneSize: 10,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 1.0],
    ),
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      height: height,
      width: width,
      constraints: constraints,
      decoration: decoration ??
          BoxDecoration(
            color: backgroundColor,
          ),
      child: ClipRRect(
        borderRadius: (decoration as BoxDecoration?)?.borderRadius ?? BorderRadius.zero,
        child: CustomPaint(
          size: Size(width ?? double.infinity, height ?? double.infinity),
          painter: HalftoneGradientPainter(
            type: gradient.type,
            color: gradient.color,
            halftoneSize: gradient.halftoneSize,
            begin: gradient.begin,
            end: gradient.end,
            stops: gradient.stops,
          ),
          child: child, // 전달된 child 위젯을 포함
        ),
      ),
    );
  }
}
