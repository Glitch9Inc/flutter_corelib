import 'package:flutter/material.dart';

class Metric {
  String get id => abbreviation;
  final String abbreviation;
  final String singular;
  final String plural;
  final IconData icon;
  final bool isEmpty;
  final double minValue;
  final double maxValue;
  final double interval;

  const Metric({
    required this.abbreviation,
    required this.singular,
    required this.plural,
    required this.icon,
    this.isEmpty = false,
    this.minValue = 0,
    this.maxValue = double.infinity,
    this.interval = 1,
  });

  Metric copyWith({IconData? icon, double? min, double? max, double? interval}) {
    return Metric(
      abbreviation: abbreviation,
      singular: singular,
      plural: plural,
      icon: icon ?? this.icon,
      isEmpty: isEmpty,
      minValue: min ?? minValue,
      maxValue: max ?? maxValue,
      interval: interval ?? this.interval,
    );
  }

  factory Metric.fromAbbreviation(String abbr) {
    switch (abbr) {
      case 'cm':
        return Metric.cm;
      case 'ft':
        return Metric.ft;
      case 'kg':
        return Metric.kg;
      case 'lb':
        return Metric.lb;
      case 'km':
        return Metric.km;
      case 'mi':
        return Metric.mi;
      case 'inch':
        return Metric.inch;
      case 'steps':
        return Metric.steps;
      case 'min':
        return Metric.min;
      case 'hour':
        return Metric.hour;
      case 'kcal':
        return Metric.kcal;
      case 'bpm':
        return Metric.bpm;
      case 'pts':
        return Metric.pts;
      case 'likes':
        return Metric.likes;
      default:
        return Metric.none;
    }
  }

  @override
  operator ==(Object other) {
    if (other is Metric) {
      return abbreviation == other.abbreviation;
    }
    return false;
  }

  @override
  int get hashCode => abbreviation.hashCode;

  @override
  String toString() => plural;

  static const Metric cm = Metric(
    abbreviation: 'cm',
    singular: 'Centimeter',
    plural: 'Centimeters',
    icon: Icons.straighten, // 자나 길이를 나타내는 아이콘
  );

  static const Metric ft = Metric(
    abbreviation: 'ft',
    singular: 'Foot',
    plural: 'Feet',
    icon: Icons.straighten, // 자를 나타내는 아이콘
  );

  static const Metric kg = Metric(
    abbreviation: 'kg',
    singular: 'Kilogram',
    plural: 'Kilograms',
    icon: Icons.fitness_center, // 역기 아이콘
  );

  static const Metric lb = Metric(
    abbreviation: 'lb',
    singular: 'Pound',
    plural: 'Pounds',
    icon: Icons.scale, // 무게를 측정하는 저울 아이콘
  );

  static const Metric km = Metric(
    abbreviation: 'km',
    singular: 'Kilometer',
    plural: 'Kilometers',
    icon: Icons.location_on, // 위치를 나타내는 아이콘
  );

  static const Metric mi = Metric(
    abbreviation: 'mi',
    singular: 'Mile',
    plural: 'Miles',
    icon: Icons.location_on, // 위치를 나타내는 아이콘
  );

  static const Metric inch = Metric(
    abbreviation: 'inch',
    singular: 'Inch',
    plural: 'Inches',
    icon: Icons.straighten, // 길이를 나타내는 아이콘
  );

  // 밀리리터
  static const Metric ml = Metric(
    abbreviation: 'ml',
    singular: 'Milliliter',
    plural: 'Milliliters',
    icon: Icons.local_drink, // 마시는 것을 나타내는 아이콘
  );

  // 온즈
  static const Metric oz = Metric(
    abbreviation: 'oz',
    singular: 'Ounce',
    plural: 'Ounces',
    icon: Icons.local_drink, // 마시는 것을 나타내는 아이콘
  );

  static const Metric steps = Metric(
    abbreviation: 'steps',
    singular: 'Step',
    plural: 'Steps',
    icon: Icons.directions_walk, // 걷기를 나타내는 아이콘
  );

  static const Metric min = Metric(
    abbreviation: 'min',
    singular: 'Minute',
    plural: 'Minutes',
    icon: Icons.timer, // 타이머 아이콘
  );

  static const Metric hour = Metric(
    abbreviation: 'hour',
    singular: 'Hour',
    plural: 'Hours',
    icon: Icons.access_time, // 시간을 나타내는 아이콘
  );

  static const Metric kcal = Metric(
    abbreviation: 'kcal',
    singular: 'Calorie',
    plural: 'Calories',
    icon: Icons.local_fire_department, // 칼로리를 나타내는 불꽃 아이콘
  );

  static const Metric bpm = Metric(
    abbreviation: 'bpm',
    singular: 'Beat per minute',
    plural: 'Beats per minute',
    icon: Icons.favorite, // 심장 박동을 나타내는 아이콘
  );

  static const Metric pts = Metric(
    abbreviation: 'pts',
    singular: 'Point',
    plural: 'Points',
    icon: Icons.star, // 별 아이콘
  );

  static const Metric likes = Metric(
    abbreviation: 'likes',
    singular: 'Like',
    plural: 'Likes',
    icon: Icons.recommend, // 좋아요 아이콘
  );

  static const Metric times = Metric(
    abbreviation: 'times',
    singular: 'Time',
    plural: 'Times',
    icon: Icons.onetwothree, // 숫자를 나타내는 아이콘
  );

  static const Metric none = Metric(
    abbreviation: '',
    singular: '',
    plural: '',
    icon: Icons.error,
    isEmpty: true,
  );
}

abstract class MetricConverter {
  static num kbToLb(num value) => value * 2.20462;
  static num lbToKb(num value) => value / 2.20462;
  static num cmToFt(num value) => value * 0.0328084;
  static num ftToCm(num value) => value / 0.0328084;
  static num kmToMi(num value) => value * 0.621371;
  static num miToKm(num value) => value / 0.621371;
  static num cmToInch(num value) => value * 0.393701;
  static num inchToCm(num value) => value / 0.393701;

  static num convertValue(num value, Metric from, Metric to) {
    if (from == to) {
      return value;
    }

    if (from == Metric.kg && to == Metric.lb) {
      return MetricConverter.kbToLb(value);
    } else if (from == Metric.lb && to == Metric.kg) {
      return MetricConverter.lbToKb(value);
    } else if (from == Metric.cm && to == Metric.ft) {
      return MetricConverter.cmToFt(value);
    } else if (from == Metric.ft && to == Metric.cm) {
      return MetricConverter.ftToCm(value);
    } else if (from == Metric.km && to == Metric.mi) {
      return MetricConverter.kmToMi(value);
    } else if (from == Metric.mi && to == Metric.km) {
      return MetricConverter.miToKm(value);
    } else if (from == Metric.cm && to == Metric.inch) {
      return MetricConverter.cmToInch(value);
    } else if (from == Metric.inch && to == Metric.cm) {
      return MetricConverter.inchToCm(value);
    }

    return value;
  }
}
