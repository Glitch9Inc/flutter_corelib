import 'package:flutter/material.dart';

class ItemPickerItem {
  final int index;
  final IconData? iconData;
  final String? iconAsset;
  final String title;
  final String? subtitle;

  ItemPickerItem(this.index, {this.iconData, this.iconAsset, required this.title, this.subtitle});
}
