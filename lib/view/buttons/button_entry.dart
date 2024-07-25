import 'package:flutter/material.dart';

class ButtonEntry {
  final int? index;
  final String? label;
  final Color? color;
  final Widget? icon;
  final IconData? iconData;
  final Function() onTap;
  ButtonEntry({
    this.label,
    this.color,
    this.index,
    this.icon,
    this.iconData,
    required this.onTap,
  });
}
