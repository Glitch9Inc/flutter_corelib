import 'package:flutter/material.dart';

class PopupAction {
  final String text;
  final MaterialColor? color;
  final VoidCallback? onPressed;

  PopupAction({
    required this.text,
    required this.onPressed,
    this.color,
  });
}
