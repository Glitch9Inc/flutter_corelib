import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

mixin SortableItem {
  /// Key is the [sortKey] in [SortRule]
  Map<String, String> get sortData;
  bool Function(String filterKey) get filter;
  bool Function(String searchWord) get search;
}

class SortRule extends RuleBase {
  SortRule(
    super.key, {
    super.name = '',
    super.icon,
    super.iconData,
    super.iconPath,
    super.iconSize = 18,
    super.iconColor,
    super.helpMessage,
  });
}

class FilterRule extends RuleBase {
  FilterRule(
    super.key, {
    super.name = '',
    super.icon,
    super.iconData,
    super.iconPath,
    super.iconSize = 18,
    super.iconColor,
    super.helpMessage,
  });
}

class RuleBase {
  // Core Data
  final String key;

  // UI Data
  final String name;
  late final Widget? icon;
  final InfoMessage? helpMessage;

  RuleBase(
    this.key, {
    this.name = '',
    this.icon,
    IconData? iconData,
    String? iconPath,
    double iconSize = 18,
    Color? iconColor,
    this.helpMessage,
  }) {
    if (icon == null) {
      if (iconData != null) {
        icon = Icon(iconData, size: iconSize, color: iconColor);
      } else if (iconPath != null) {
        icon = Image.asset(iconPath, width: iconSize, height: iconSize);
      }
    }
  }
}
