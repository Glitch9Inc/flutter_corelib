import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class IconButtonBox extends StatelessWidget {
  final Widget icon;
  final Color color;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxBorder? shape;
  final VoidCallback? onPressed;

  const IconButtonBox({
    super.key,
    required this.icon,
    this.color = Colors.white,
    this.backgroundColor = semiTransparentBlack,
    this.borderRadius,
    this.shape,
    this.onPressed,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        border: shape,
      ),
      child: IconButton(
        icon: icon,
        color: color,
        onPressed: onPressed,
      ),
    );
  }
}
