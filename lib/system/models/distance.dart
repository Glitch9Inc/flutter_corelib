// 거리
class Distance implements Comparable<Distance> {
  static const double metersPerKilometer = 1000;
  static const double metersPerFeet = 0.3048;
  static const double metersPerMile = 1609.34;

  /// An empty distance, representing zero distance.
  static const Distance zero = Distance(meters: 0);

  /// The total meters of this [Distance] object.
  final double _distance;

  const Distance({double meters = 0, double kilometers = 0, double feets = 0, double miles = 0})
      : this._meters(meters + kilometers * metersPerKilometer + feets * metersPerFeet + miles * metersPerMile);

  // Fast path doubleernal direct constructor to avoids the optional arguments
  // and [_meters] recomputation.
  // The `+ 0` prevents -0.0 on the web, if the incoming liquid distance happens to be -0.0.
  const Distance._meters(double distance) : _distance = distance + 0;

  /// Adds this Distance and [other] and
  /// returns the sum as a new Distance object.
  Distance operator +(Distance other) {
    return Distance._meters(_distance + other._distance);
  }

  /// Subtracts [other] from this Distance and
  /// returns the difference as a new Distance object.
  Distance operator -(Distance other) {
    return Distance._meters(_distance - other._distance);
  }

  /// Multiplies this Distance by the given [factor] and returns the result
  /// as a new Distance object.
  ///
  /// Note that when [factor] is a double, and the distance is greater than
  /// 53 bits, precision is lost because of double-precision arithmetic.
  Distance operator *(num factor) {
    return Distance._meters((_distance * factor));
  }

  /// Divides this Distance by the given [quotient] and returns the truncated
  /// result as a new Distance object.
  ///
  /// The [quotient] must not be `0`.
  Distance operator ~/(double quotient) {
    // By doing the check here instead of relying on "~/" below we get the
    // exception even with dart2js.
    if (quotient == 0) throw const IntegerDivisionByZeroException();
    return Distance._meters(_distance / quotient);
  }

  /// Whether this [Distance] is shorter than [other].
  bool operator <(Distance other) => this._distance < other._distance;

  /// Whether this [Distance] is longer than [other].
  bool operator >(Distance other) => this._distance > other._distance;

  /// Whether this [Distance] is shorter than or equal to [other].
  bool operator <=(Distance other) => this._distance <= other._distance;

  /// Whether this [Distance] is longer than or equal to [other].
  bool operator >=(Distance other) => this._distance >= other._distance;

  double get inKilometers => _distance / Distance.metersPerKilometer;
  double get inMillikilometers => _distance;
  double get inFeets => _distance / Distance.metersPerFeet;
  double get inMiles => _distance / Distance.metersPerMile;

  /// Whether this [Distance] has the same length as [other].
  ///
  /// Distances have the same length if they have the same number
  /// of microseconds, as reported by [inMillikilometers].
  @override
  bool operator ==(Object other) => other is Distance && _distance == other.inMillikilometers;

  @override
  int get hashCode => _distance.hashCode;

  /// Compares this [Distance] to [other], returning zero if the values are equal.
  ///
  /// Returns a negative doubleeger if this [Distance] is shorter than
  /// [other], or a positive doubleeger if it is longer.
  ///
  /// A negative [Distance] is always considered shorter than a positive one.
  ///
  /// It is always the case that `distance1.compareTo(distance2) < 0` iff
  /// `(someDate + distance1).compareTo(someDate + distance2) < 0`.
  @override
  int compareTo(Distance other) => _distance.compareTo(other._distance);

  @override
  String toString() {
    if (_distance == 0) return '0m';
    if (_distance < 0) return '${-inMillikilometers}m';
    if (_distance < 1000) return '${_distance.toStringAsFixed(0)}m';
    if (_distance < 10000) return '${(_distance / 1000).toStringAsFixed(1)}km';
    return '${(_distance / 1000).toStringAsFixed(0)}km';
  }

  /// Whether this [Distance] is negative.
  ///
  /// A negative [Distance] represents the difference from a later time to an
  /// earlier time.
  bool get isNegative => _distance < 0;

  /// Creates a new [Distance] representing the absolute length of this
  /// [Distance].
  ///
  /// The returned [Distance] has the same length as this one, but is always
  /// positive where possible.
  Distance abs() => Distance._meters(_distance.abs());

  /// Creates a new [Distance] with the opposite direction of this [Distance].
  ///
  /// The returned [Distance] has the same length as this one, but will have the
  /// opposite sign (as reported by [isNegative]) as this one where possible.
  // Using subtraction helps dart2js avoid negative zeros.
  Distance operator -() => Distance._meters(0 - _distance);
}
