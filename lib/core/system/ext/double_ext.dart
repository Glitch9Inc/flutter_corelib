import 'dart:math';

import 'package:flutter/material.dart';

extension DoubleExt on double {
  get radians => this * (3.1415926535897932 / 180.0);
  get degrees => this * (180.0 / 3.1415926535897932);
  get fix3 => toStringAsFixed(3);
  get fix2 => toStringAsFixed(2);
  get vertInsets => EdgeInsets.symmetric(vertical: this);
  get horiInsets => EdgeInsets.symmetric(horizontal: this);
  get allInsets => EdgeInsets.all(toDouble());
  get sizedBold => TextStyle(fontSize: this, fontWeight: FontWeight.bold);
  get bold => const TextStyle(fontWeight: FontWeight.bold);

  bool chance({double reduction = 0, double? minValue}) {
    var finalChance = this - reduction;
    if (minValue != null) finalChance = max(finalChance, minValue);
    return Random().nextDouble() < finalChance;
  }
}
