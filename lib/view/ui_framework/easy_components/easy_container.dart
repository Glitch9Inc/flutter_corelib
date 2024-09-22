import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class EasyContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? color;
  final UIColor uiColor;
  final Widget? child;
  final double containerThickness;
  final double borderWidth;
  final BorderDirection borderDirection;

  const EasyContainer({
    super.key,
    this.color,
    this.uiColor = UIColor.blue,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius,
    this.borderWidth = 2,
    this.borderDirection = BorderDirection.all,
    this.containerThickness = 3,
    this.child,
  });

  BoxDecoration _resolveDecoration() {
    if (uiColor == UIColor.gold) {
      Color lightColor = routinaYellowW300;
      Color darkColor = routinaBrownW200;

      return BoxDecoration(
        borderRadius: borderDirection.resolveBorderRadius(borderRadius),
        gradient: LinearGradient(
          colors: [
            lightColor,
            darkColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: borderDirection.resolveBorder(darkColor, borderWidth),
        boxShadow: getCartoonBoxShadow(color: darkColor.darken(0.15), thickness: containerThickness),
      );
    }

    Color keyColor = color ?? uiColor.color[500]!;
    Color lightColor = color != null ? color!.brighten(0.2) : uiColor.color[300]!;

    return BoxDecoration(
      borderRadius: borderDirection.resolveBorderRadius(borderRadius),
      gradient: LinearGradient(
        colors: [
          keyColor,
          lightColor,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      border: borderDirection.resolveBorder(keyColor, borderWidth),
      boxShadow: getCartoonBoxShadow(color: keyColor.darken(0.15), thickness: containerThickness),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: _resolveDecoration(),
      child: Center(
        child: child,
      ),
    );
  }
}
