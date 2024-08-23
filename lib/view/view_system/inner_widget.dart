import 'package:flutter/material.dart';

abstract class InnerWidget extends StatelessWidget {
  abstract final String title;
  final bool showCloseButton;
  final bool hasHeader;
  final Color? backgroundColor;
  final Widget? button;

  const InnerWidget({
    super.key,
    this.showCloseButton = true,
    this.hasHeader = true,
    this.backgroundColor,
    this.button,
  });
}
