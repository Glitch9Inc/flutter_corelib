import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.largeTablet,
    required this.tablet,
    required this.mobile,
  });

  final Widget largeTablet;
  final Widget tablet;
  final Widget mobile;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  static bool isLargeTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1000;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (size.width >= 1000) {
      return largeTablet;
    } else if (size.width >= 600) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
