import 'package:flutter/material.dart';

class ItemEntry {
  final int index;
  final String name;
  final Widget? icon;

  ItemEntry({required this.name, this.index = 0, this.icon});
}
