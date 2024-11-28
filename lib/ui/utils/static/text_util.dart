import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_corelib/ui/styles/shadows/text_shadows.dart';

abstract class TextUtil {
  static TextStyle generateGradatedTextStyle(Color color1, Color color2,
      {double fontSize = 18, List<Shadow>? shadows, double height = 1.2}) {
    final Shader linearGradientShader = ui.Gradient.linear(const Offset(0, 0), const Offset(0, 24), <Color>[color1, color2]);
    shadows ??= getTextOutline(1);

    return TextStyle(
      foreground: Paint()..shader = linearGradientShader,
      fontWeight: FontWeight.bold,
      shadows: shadows,
      fontSize: fontSize,
      height: height,
    );
  }
}
