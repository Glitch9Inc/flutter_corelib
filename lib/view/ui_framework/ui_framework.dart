import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

abstract class UIFramework {
  static const Color fallbackColor = Colors.black;
  static const Map<UIColor, MaterialColor> _uiMaterialColors = {
    UIColor.blue: routinaBlue,
    UIColor.green: routinaGreen,
    UIColor.red: routinaRed,
    UIColor.orange: routinaOrange,
    UIColor.grey: routinaGrey,
    UIColor.yellow: routinaYellow,
    UIColor.blueGrey: routinaBlueGrey,
    UIColor.purple: routinaPurple,
    UIColor.cyan: routinaCyan,
    UIColor.gold: routinaYellow, // placeholder
    UIColor.pink: routinaPink,
    UIColor.indigo: routinaIndigo,
    UIColor.darkGrey: routinaDarkGrey,
    UIColor.teal: Colors.teal,
  };

  static MaterialColor createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    final Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  static MaterialColor getMaterialColor(UIColor color) {
    return _uiMaterialColors[color] ?? createMaterialColor(fallbackColor);
  }
}
