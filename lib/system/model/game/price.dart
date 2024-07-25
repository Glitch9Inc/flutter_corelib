import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class Price implements Comparable {
  final String name;
  final String icon;
  int _value;

  int get value => _value;
  set value(int val) => _value = val;

  Price(int value, {required this.name, required this.icon}) : _value = value;

  @override
  bool operator ==(Object other) => other is Price && value == other.value;
  bool operator <(Price other) => value < other.value;
  bool operator >(Price other) => value > other.value;
  bool operator <=(Price other) => value <= other.value;
  bool operator >=(Price other) => value >= other.value;

  @override
  int get hashCode => value.hashCode;

  int operator +(dynamic other) {
    if (other is Price) return value + other.value;
    if (other is int) return value + other;
    throw ArgumentError('Invalid operand type');
  }

  int operator -(dynamic other) {
    if (other is Price) return value - other.value;
    if (other is int) return value - other;
    throw ArgumentError('Invalid operand type');
  }

  int operator *(dynamic other) {
    if (other is Price) return value * other.value;
    if (other is int) return value * other;
    throw ArgumentError('Invalid operand type');
  }

  int operator /(dynamic other) {
    if (other is Price) return value ~/ other.value;
    if (other is int) return value ~/ other;
    throw ArgumentError('Invalid operand type');
  }

  @override
  int compareTo(dynamic other) {
    if (other is Price) {
      if (value < other.value) return -1;
      if (value > other.value) return 1;
      return 0;
    }
    if (other is int) {
      if (value < other) return -1;
      if (value > other) return 1;
      return 0;
    }
    throw ArgumentError('Invalid operand type');
  }
}

extension PriceExt on Price {
  Row toRow({double iconSize = 20, double spacing = 3}) {
    double fontSize = iconSize * 0.8;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          icon,
          width: iconSize,
          height: iconSize,
        ),
        SizedBox(width: spacing),
        AutoSizeText(value.toString(),
            style: Get.textTheme.bodyMedium!.copyWith(fontSize: fontSize)),
      ],
    );
  }

  Container toContainer(
      {double iconSize = 20,
      double spacing = 3,
      BorderRadius borderRadius = const BorderRadius.all(Radius.circular(20)),
      Color backgroundColor = semiTransparentBlack}) {
    double horizontalPadding = iconSize / 2;
    double verticalPadding = iconSize / 4;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor,
      ),
      child: toRow(iconSize: iconSize, spacing: spacing),
    );
  }
}
