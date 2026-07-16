// Weight
class Weight implements Comparable<Weight> {
  static const double gramsPerKilogram = 1000;
  static const double gramsPerPound = 453.592;
  static const double gramsPerOunce = 28.3495;

  /// An empty weight, representing zero weight.
  static const Weight zero = Weight(grams: 0);

  /// The total grams of this [Weight] object.
  final double _weight;

  const Weight({double grams = 0, double kilograms = 0, double pounds = 0, double ounces = 0})
      : this._grams(grams + kilograms * gramsPerKilogram + pounds * gramsPerPound + ounces * gramsPerOunce);

  const Weight._grams(double weight) : _weight = weight + 0;

  Weight operator +(Weight other) {
    return Weight._grams(_weight + other._weight);
  }

  Weight operator -(Weight other) {
    return Weight._grams(_weight - other._weight);
  }

  Weight operator *(num factor) {
    return Weight._grams(_weight * factor);
  }

  Weight operator ~/(double quotient) {
    if (quotient == 0) throw UnsupportedError('Cannot divide by zero');
    return Weight._grams(_weight / quotient);
  }

  bool operator <(Weight other) => _weight < other._weight;
  bool operator >(Weight other) => _weight > other._weight;
  bool operator <=(Weight other) => _weight <= other._weight;
  bool operator >=(Weight other) => _weight >= other._weight;

  double get inKilograms => _weight / Weight.gramsPerKilogram;
  double get inPounds => _weight / Weight.gramsPerPound;
  double get inOunces => _weight / Weight.gramsPerOunce;
  double get inGrams => _weight;

  @override
  bool operator ==(Object other) => other is Weight && _weight == other._weight;

  @override
  int get hashCode => _weight.hashCode;

  @override
  int compareTo(Weight other) => _weight.compareTo(other._weight);

  @override
  String toString() {
    if (_weight == 0) return '0g';
    if (_weight < 1000) return '${_weight.toStringAsFixed(0)}g';
    return '${(_weight / 1000).toStringAsFixed(2)}kg';
  }

  bool get isNegative => _weight < 0;
  Weight abs() => Weight._grams(_weight.abs());
  Weight operator -() => Weight._grams(0 - _weight);
}
