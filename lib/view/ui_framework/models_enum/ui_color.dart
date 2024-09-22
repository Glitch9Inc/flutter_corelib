import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

enum UIColor {
  blue,
  green,
  red,
  orange,
  grey,
  yellow,
  blueGrey,
  purple,
  cyan,
  gold,
  pink,
  indigo,
}

extension UIColorExt on UIColor {
  Color get lightColor => UIFramework.getMaterialColor(this).shade100;
  Color get darkColor => UIFramework.getMaterialColor(this).shade800;
  MaterialColor get color => UIFramework.getMaterialColor(this);
}
