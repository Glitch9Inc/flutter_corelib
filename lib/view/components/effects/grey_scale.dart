import 'package:flutter/material.dart';

class GreyScale extends StatelessWidget {
  final Widget child;
  final double opacity;

  const GreyScale({super.key, required this.child, this.opacity = 0.5});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.grey.withOpacity(opacity),
        BlendMode.saturation,
      ),
      child: child,
    );
  }
}
