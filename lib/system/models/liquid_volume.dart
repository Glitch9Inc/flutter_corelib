// 액체 용량
class LiquidVolume implements Comparable<LiquidVolume> {
  static const int millilitersPerLiter = 1000;
  static const int millilitersPerCup = 250;
  static const int millilitersPerPint = 568;
  static const int millilitersPerQuart = 1136;
  static const int millilitersPerGallon = 4546;
  static const int millilitersPerOunce = 28;

  /// An empty volume, representing zero volume.
  static const LiquidVolume zero = LiquidVolume(milliliters: 0);

  /// The total milliliters of this [LiquidVolume] object.
  final int _liquidVolume;

  const LiquidVolume(
      {int milliliters = 0,
      int liters = 0,
      int cups = 0,
      int pints = 0,
      int quarts = 0,
      int gallons = 0,
      int ounces = 0})
      : this._milliliters(milliliters +
            liters * millilitersPerLiter +
            cups * millilitersPerCup +
            pints * millilitersPerPint +
            quarts * millilitersPerQuart +
            gallons * millilitersPerGallon +
            ounces * millilitersPerOunce);

  // Fast path internal direct constructor to avoids the optional arguments
  // and [_milliliters] recomputation.
  // The `+ 0` prevents -0.0 on the web, if the incoming liquid volume happens to be -0.0.
  const LiquidVolume._milliliters(int liquidVolume)
      : _liquidVolume = liquidVolume + 0;

  /// Adds this LiquidVolume and [other] and
  /// returns the sum as a new LiquidVolume object.
  LiquidVolume operator +(LiquidVolume other) {
    return LiquidVolume._milliliters(_liquidVolume + other._liquidVolume);
  }

  /// Subtracts [other] from this LiquidVolume and
  /// returns the difference as a new LiquidVolume object.
  LiquidVolume operator -(LiquidVolume other) {
    return LiquidVolume._milliliters(_liquidVolume - other._liquidVolume);
  }

  /// Multiplies this LiquidVolume by the given [factor] and returns the result
  /// as a new LiquidVolume object.
  ///
  /// Note that when [factor] is a double, and the liquidVolume is greater than
  /// 53 bits, precision is lost because of double-precision arithmetic.
  LiquidVolume operator *(num factor) {
    return LiquidVolume._milliliters((_liquidVolume * factor).round());
  }

  /// Divides this LiquidVolume by the given [quotient] and returns the truncated
  /// result as a new LiquidVolume object.
  ///
  /// The [quotient] must not be `0`.
  LiquidVolume operator ~/(int quotient) {
    // By doing the check here instead of relying on "~/" below we get the
    // exception even with dart2js.
    if (quotient == 0) throw UnsupportedError('Cannot divide by zero');
    return LiquidVolume._milliliters(_liquidVolume ~/ quotient);
  }

  /// Whether this [LiquidVolume] is shorter than [other].
  bool operator <(LiquidVolume other) => _liquidVolume < other._liquidVolume;

  /// Whether this [LiquidVolume] is longer than [other].
  bool operator >(LiquidVolume other) => _liquidVolume > other._liquidVolume;

  /// Whether this [LiquidVolume] is shorter than or equal to [other].
  bool operator <=(LiquidVolume other) => _liquidVolume <= other._liquidVolume;

  /// Whether this [LiquidVolume] is longer than or equal to [other].
  bool operator >=(LiquidVolume other) => _liquidVolume >= other._liquidVolume;

  int get inLiters => _liquidVolume ~/ LiquidVolume.millilitersPerLiter;
  int get inMilliliters => _liquidVolume;
  int get inCups => _liquidVolume ~/ LiquidVolume.millilitersPerCup;
  int get inPints => _liquidVolume ~/ LiquidVolume.millilitersPerPint;
  int get inQuarts => _liquidVolume ~/ LiquidVolume.millilitersPerQuart;
  int get inGallons => _liquidVolume ~/ LiquidVolume.millilitersPerGallon;
  int get inOunces => _liquidVolume ~/ LiquidVolume.millilitersPerOunce;

  /// Whether this [LiquidVolume] has the same length as [other].
  ///
  /// LiquidVolumes have the same length if they have the same number
  /// of microseconds, as reported by [inMilliliters].
  @override
  bool operator ==(Object other) =>
      other is LiquidVolume && _liquidVolume == other.inMilliliters;

  @override
  int get hashCode => _liquidVolume.hashCode;

  /// Compares this [LiquidVolume] to [other], returning zero if the values are equal.
  ///
  /// Returns a negative integer if this [LiquidVolume] is shorter than
  /// [other], or a positive integer if it is longer.
  ///
  /// A negative [LiquidVolume] is always considered shorter than a positive one.
  ///
  /// It is always the case that `liquidVolume1.compareTo(liquidVolume2) < 0` iff
  /// `(someDate + liquidVolume1).compareTo(someDate + liquidVolume2) < 0`.
  @override
  int compareTo(LiquidVolume other) =>
      _liquidVolume.compareTo(other._liquidVolume);

  @override
  String toString() {
    final milliliters = inMilliliters;
    final ounces = inOunces;

    return '$milliliters ml ($ounces oz)';
  }

  /// Whether this [LiquidVolume] is negative.
  ///
  /// A negative [LiquidVolume] represents the difference from a later time to an
  /// earlier time.
  bool get isNegative => _liquidVolume < 0;

  /// Creates a new [LiquidVolume] representing the absolute length of this
  /// [LiquidVolume].
  ///
  /// The returned [LiquidVolume] has the same length as this one, but is always
  /// positive where possible.
  LiquidVolume abs() => LiquidVolume._milliliters(_liquidVolume.abs());

  /// Creates a new [LiquidVolume] with the opposite direction of this [LiquidVolume].
  ///
  /// The returned [LiquidVolume] has the same length as this one, but will have the
  /// opposite sign (as reported by [isNegative]) as this one where possible.
  // Using subtraction helps dart2js avoid negative zeros.
  LiquidVolume operator -() => LiquidVolume._milliliters(0 - _liquidVolume);
}
