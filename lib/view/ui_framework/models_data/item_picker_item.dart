import 'package:flutter/material.dart';

class ItemPickerItem {
  final int index;
  final IconData? iconData;
  final String? iconAsset;
  final String title;
  final String? subtitle;

  ItemPickerItem(
    this.index, {
    this.iconData,
    this.iconAsset,
    required this.title,
    this.subtitle,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemPickerItem &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.iconData == iconData &&
        other.iconAsset == iconAsset;
  }

  @override
  int get hashCode {
    return title.hashCode ^ subtitle.hashCode ^ iconData.hashCode ^ iconAsset.hashCode;
  }
}
