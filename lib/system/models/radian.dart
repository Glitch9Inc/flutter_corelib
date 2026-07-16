import 'dart:math';

/// 각도를 나타내는 클래스
/// - 12시: -π / 2 (기본값)
/// - 1시: -π / 3
/// - 2시: -π / 6
/// - 3시: 0
/// - 4시: π / 6
/// - 5시: π / 3
/// - 6시: π / 2
/// - 7시: 2π / 3
/// - 8시: 5π / 6
/// - 9시: π
/// - 10시: 7π / 6
/// - 11시: 4π / 3
class Radian implements Comparable<Radian> {
  /// An empty radian, representing zero radian.
  static const Radian zero = Radian(0);
  static const Radian north = Radian(-pi / 2);
  static const Radian east = Radian(0);
  static const Radian south = Radian(pi / 2);
  static const Radian west = Radian(pi);

  /// The total angle of this [Radian] object.
  final double _radian;

  const Radian(this._radian);

  /// Creates a new [Radian] object from the given clock hour.
  /// The [hour] must be in the range of `0` to `12` where `0` is same as `12`.
  factory Radian.fromClockHour(double hour) {
    if (hour < 0 || hour > 12) {
      throw RangeError.range(hour, 0, 12, 'hour');
    }

    return Radian(-pi / 6 * hour + pi / 2);
  }

  /// Adds this Radian and [other] and
  /// returns the sum as a new Radian object.
  Radian operator +(Radian other) {
    return Radian(_radian + other._radian);
  }

  /// Subtracts [other] from this Radian and
  /// returns the difference as a new Radian object.
  Radian operator -(Radian other) {
    return Radian(_radian - other._radian);
  }

  /// Multiplies this Radian by the given [factor] and returns the result
  /// as a new Radian object.
  ///
  /// Note that when [factor] is a double, and the radian is greater than
  /// 53 bits, precision is lost because of double-precision arithmetic.
  Radian operator *(num factor) {
    return Radian((_radian * factor));
  }

  /// Divides this Radian by the given [quotient] and returns the truncated
  /// result as a new Radian object.
  ///
  /// The [quotient] must not be `0`.
  Radian operator ~/(double quotient) {
    // By doing the check here instead of relying on "~/" below we get the
    // exception even with dart2js.
    if (quotient == 0) throw UnsupportedError('Division by zero');
    return Radian(_radian / quotient);
  }

  /// Whether this [Radian] is shorter than [other].
  bool operator <(Radian other) => _radian < other._radian;

  /// Whether this [Radian] is longer than [other].
  bool operator >(Radian other) => _radian > other._radian;

  /// Whether this [Radian] is shorter than or equal to [other].
  bool operator <=(Radian other) => _radian <= other._radian;

  /// Whether this [Radian] is longer than or equal to [other].
  bool operator >=(Radian other) => _radian >= other._radian;

  /// Whether this [Radian] has the same length as [other].
  @override
  bool operator ==(Object other) => other is Radian && _radian == other._radian;

  @override
  int get hashCode => _radian.hashCode;

  /// Compares this [Radian] to [other], returning zero if the values are equal.
  ///
  /// Returns a negative doubleeger if this [Radian] is shorter than
  /// [other], or a positive doubleeger if it is longer.
  ///
  /// A negative [Radian] is always considered shorter than a positive one.
  ///
  /// It is always the case that `radian1.compareTo(radian2) < 0` iff
  /// `(someDate + radian1).compareTo(someDate + radian2) < 0`.
  @override
  int compareTo(Radian other) => _radian.compareTo(other._radian);

  @override
  String toString() {
    return 'Radian($_radian)';
  }

  double toDouble() {
    return _radian;
  }

  double toClockHour() {
    return (pi / 6 - _radian) / (pi / 6);
  }

  /// Whether this [Radian] is negative.
  ///
  /// A negative [Radian] represents the difference from a later time to an
  /// earlier time.
  bool get isNegative => _radian < 0;

  /// Creates a new [Radian] representing the absolute length of this
  /// [Radian].
  ///
  /// The returned [Radian] has the same length as this one, but is always
  /// positive where possible.
  Radian abs() => Radian(_radian.abs());

  /// Creates a new [Radian] with the opposite direction of this [Radian].
  ///
  /// The returned [Radian] has the same length as this one, but will have the
  /// opposite sign (as reported by [isNegative]) as this one where possible.
  // Using subtraction helps dart2js avoid negative zeros.
  Radian operator -() => Radian(0 - _radian);
}
