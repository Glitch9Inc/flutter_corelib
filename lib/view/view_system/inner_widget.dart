import 'package:flutter/material.dart';

abstract class InnerWidget extends StatelessWidget {
  final String title;
  final bool showCloseButton;
  final Widget? backgroundEffect;

  const InnerWidget(
      {super.key,
      required this.title,
      this.backgroundEffect = null,
      this.showCloseButton = true});
}
