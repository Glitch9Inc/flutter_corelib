import 'package:flutter/material.dart';

class ItemEntry {
  final int index;
  final String name;
  final Widget? icon;
  final String? iconPath;
  final VoidCallback? onTap;

  ItemEntry({
    required this.name,
    this.index = 0,
    this.icon,
    this.iconPath,
    this.onTap,
  });
}
