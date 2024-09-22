import 'dart:ui';

import 'package:flutter_corelib/view/ui_framework/models_enum/ui_color.dart';

class DialogAction {
  final String text;
  final UIColor? uiColor;
  final VoidCallback? onPressed;

  DialogAction({
    required this.text,
    required this.onPressed,
    this.uiColor,
  });
}
