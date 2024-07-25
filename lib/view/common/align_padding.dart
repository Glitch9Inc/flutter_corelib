import 'package:flutter/material.dart';

class AlignPadding extends StatelessWidget {
  final Alignment alignment;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const AlignPadding({
    super.key,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
