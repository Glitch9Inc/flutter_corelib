import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

extension ColorExt on Color {
  Color get light {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor();
  }

  Color get lighter {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + 0.3).clamp(0.0, 1.0)).toColor();
  }

  Color get dark {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();
  }

  Color get button {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + 0.5).clamp(0.0, 1.0))
        .withSaturation((hsl.saturation + 0.5).clamp(0.0, 1.0))
        .toColor();
  }

  Color get darker {
    var hsl = HSLColor.fromColor(this);
    hsl = hsl.withLightness((hsl.lightness - 0.3).clamp(0.0, 1.0));
    hsl = hsl.withSaturation((hsl.saturation - 0.3).clamp(0.0, 1.0));
    return hsl.toColor();
  }

  Color get lessSaturated {
    var hsl = HSLColor.fromColor(this);
    hsl = hsl.withSaturation((hsl.saturation - 0.2).clamp(0.0, 1.0));
    return hsl.toColor();
  }

  Color get semiTransparent {
    return withOpacity(0.62);
  }

  /// factor: 0.0 ~ 1.0
  /// 0.0: 원래 색상
  /// 1.0: 완전 백
  Color brighten(double factor) {
    assert(factor >= 0 && factor <= 1);

    HSLColor hsl = HSLColor.fromColor(this);
    double lightness = (hsl.lightness + factor).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  Color accent() {
    return brighten(0.4).saturate(1).hue(0.9);
  }

  /// factor: 0.0 ~ 1.0
  /// 0.0: 원래 색상
  /// 1.0: 완전 흑
  Color darken(double factor) {
    assert(factor >= 0 && factor <= 1);

    HSLColor hsl = HSLColor.fromColor(this);
    double lightness = (hsl.lightness - factor).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  Color saturate(double factor) {
    assert(factor >= 0 && factor <= 1);

    // RGB to HSL 변환
    List<double> hsl = ColorUtil.rgbToHsl(red, green, blue);
    double h = hsl[0], s = hsl[1], l = hsl[2];

    // 채도 증가
    s = s + (1 - s) * factor;

    // HSL을 다시 RGB로 변환
    return ColorUtil.hslToRgb(h, s, l, alpha);
  }

  Color desaturate(double factor) {
    assert(factor >= 0 && factor <= 1);

    // RGB to HSL 변환
    List<double> hsl = ColorUtil.rgbToHsl(red, green, blue);
    double h = hsl[0], s = hsl[1], l = hsl[2];

    // 채도 줄이기
    s = s * (1 - factor);

    // HSL을 다시 RGB로 변환
    return ColorUtil.hslToRgb(h, s, l, alpha);
  }

  /// hueBias: 색상 편향 (R쪽으로 0.0, G쪽으로 0.5, B쪽으로 1.0)
  Color hue(double hueBias) {
    assert(hueBias >= 0 && hueBias <= 1);

    // RGB to HSL conversion
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;
    double maxValue = [r, g, b].reduce(max);
    double minValue = [r, g, b].reduce(min);
    double h, s, l = (maxValue + minValue) / 2;

    if (maxValue == minValue) {
      h = s = 0; // achromatic
    } else {
      double d = maxValue - minValue;
      s = l > 0.5 ? d / (2 - maxValue - minValue) : d / (maxValue + minValue);
      if (maxValue == r) {
        h = (g - b) / d + (g < b ? 6 : 0);
      } else if (maxValue == g) {
        h = (b - r) / d + 2;
      } else {
        h = (r - g) / d + 4;
      }
      h /= 6;
    }

    // Apply hue bias
    h = (hueBias + h) % 1.0;

    // HSL to RGB conversion
    double q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    double p = 2 * l - q;

    double hueToRgb(double p, double q, double t) {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (t < 1 / 6) return p + (q - p) * 6 * t;
      if (t < 1 / 2) return q;
      if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
      return p;
    }

    r = hueToRgb(p, q, h + 1 / 3);
    g = hueToRgb(p, q, h);
    b = hueToRgb(p, q, h - 1 / 3);

    return Color.fromARGB(
      alpha,
      (r * 255).round(),
      (g * 255).round(),
      (b * 255).round(),
    );
  }

  Color contrast() {
    double luminance = (0.299 * red + 0.587 * green + 0.114 * blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  Color getBrightest() {
    // 흰색에 가깝지만 흰색이 아닌 포인트 색상을 반환한다.
    // RGB중 가장 큰값과 두번째로 큰값을 구한다.
    List<int> rgb = [red, green, blue];
    rgb.sort();
    int max1 = rgb[2];
    int max2 = rgb[1];
    // 가장 큰값의 비중을 구한다.
    double weight = max1 / (max1 + max2);
    // 가장 큰값과 두번째로 큰값의 차이를 구한다.
    int diff = max1 - max2;
    // 가장 큰값과 두번째로 큰값의 차이를 가장 큰값의 비중에 맞춰서 더한다.
    int value = max1 + (diff * weight).round();
    return Color.fromARGB(alpha, value, value, value).saturate(1);
  }

  Color getAccent() {
    const double saturateFactor = 0;
    const double brightenFactor = .5;
    return brighten(brightenFactor).saturate(saturateFactor);
  }

  Color complementary() {
    return Color.fromARGB(
      alpha,
      255 - red,
      255 - green,
      255 - blue,
    );
  }
}
