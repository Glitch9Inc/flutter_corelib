import 'package:flutter/material.dart';

class HorizontalSpace extends StatelessWidget {
  final double height;
  const HorizontalSpace(this.height);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class VerticalSpace extends StatelessWidget {
  final double width;
  const VerticalSpace(this.width);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
