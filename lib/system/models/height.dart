// Height
class Height implements Comparable<Height> {
  static const double metersPerCentimeter = 0.01;
  static const double metersPerInch = 0.0254;
  static const double metersPerFoot = 0.3048;

  /// An empty height, representing zero height.
  static const Height zero = Height(meters: 0);

  /// The total meters of this [Height] object.
  final double _height;

  const Height({double meters = 0, double centimeters = 0, double inches = 0, double feet = 0})
      : this._meters(meters + centimeters * metersPerCentimeter + inches * metersPerInch + feet * metersPerFoot);

  const Height._meters(double height) : _height = height + 0;

  Height operator +(Height other) {
    return Height._meters(_height + other._height);
  }

  Height operator -(Height other) {
    return Height._meters(_height - other._height);
  }

  Height operator *(num factor) {
    return Height._meters(_height * factor);
  }

  Height operator ~/(double quotient) {
    if (quotient == 0) throw UnsupportedError('Cannot divide by zero');
    return Height._meters(_height / quotient);
  }

  bool operator <(Height other) => _height < other._height;
  bool operator >(Height other) => _height > other._height;
  bool operator <=(Height other) => _height <= other._height;
  bool operator >=(Height other) => _height >= other._height;

  double get inCentimeters => _height / Height.metersPerCentimeter;
  double get inInches => _height / Height.metersPerInch;
  double get inFeet => _height / Height.metersPerFoot;
  double get inMeters => _height;

  @override
  bool operator ==(Object other) => other is Height && _height == other._height;

  @override
  int get hashCode => _height.hashCode;

  @override
  int compareTo(Height other) => _height.compareTo(other._height);

  @override
  String toString() {
    if (_height == 0) return '0m';
    if (_height < 1) return '${(_height * 100).toStringAsFixed(1)}cm';
    return '${_height.toStringAsFixed(2)}m';
  }

  bool get isNegative => _height < 0;
  Height abs() => Height._meters(_height.abs());
  Height operator -() => Height._meters(0 - _height);
}
