import 'dart:ui';

abstract class ColorUtil {
  // RGB to HSL 변환
  static List<double> rgbToHsl(int red, int green, int blue) {
    final double r = red / 255.0;
    final double g = green / 255.0;
    final double b = blue / 255.0;

    final double max = [r, g, b].reduce((a, b) => a > b ? a : b);
    final double min = [r, g, b].reduce((a, b) => a < b ? a : b);
    final double l = (max + min) / 2.0;

    double h, s;

    if (max == min) {
      h = 0;
      s = 0; // 채도가 0이면 hue는 정의되지 않음
    } else {
      final double delta = max - min;

      s = l > 0.5 ? delta / (2.0 - max - min) : delta / (max + min);

      if (max == r) {
        h = (g - b) / delta + (g < b ? 6 : 0);
      } else if (max == g) {
        h = (b - r) / delta + 2;
      } else {
        h = (r - g) / delta + 4;
      }

      h /= 6;
    }

    return [h, s, l];
  }

  // HSL to RGB 변환
  static Color hslToRgb(double h, double s, double l, int alpha) {
    double q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    double p = 2 * l - q;

    double toRGB(double t) {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (t < 1 / 6) return p + (q - p) * 6 * t;
      if (t < 1 / 2) return q;
      if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
      return p;
    }

    final int newRed = (toRGB(h + 1 / 3) * 255).round();
    final int newGreen = (toRGB(h) * 255).round();
    final int newBlue = (toRGB(h - 1 / 3) * 255).round();

    return Color.fromARGB(alpha, newRed, newGreen, newBlue);
  }
}
