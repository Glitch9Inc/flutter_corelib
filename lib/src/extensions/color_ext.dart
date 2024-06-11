import 'package:flutter/material.dart';

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
}
