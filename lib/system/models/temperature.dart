// Temperature
class Temperature implements Comparable<Temperature> {
  /// Constants for conversion.
  static const double kelvinOffset = 273.15;
  static const double fahrenheitMultiplier = 9 / 5;
  static const double fahrenheitOffset = 32;

  /// The temperature in Celsius.
  final double _celsius;

  /// Constructor accepting temperature in Celsius.
  const Temperature.celsius(this._celsius);

  /// Factory constructor for temperature in Kelvin.
  factory Temperature.kelvin(double kelvin) {
    return Temperature.celsius(kelvin - kelvinOffset);
  }

  /// Factory constructor for temperature in Fahrenheit.
  factory Temperature.fahrenheit(double fahrenheit) {
    return Temperature.celsius(
        (fahrenheit - fahrenheitOffset) / fahrenheitMultiplier);
  }

  /// Gets the temperature in Celsius.
  double get inCelsius => _celsius;

  /// Gets the temperature in Kelvin.
  double get inKelvin => _celsius + kelvinOffset;

  /// Gets the temperature in Fahrenheit.
  double get inFahrenheit => _celsius * fahrenheitMultiplier + fahrenheitOffset;

  /// Adds two temperatures (in Celsius) and returns a new Temperature.
  Temperature operator +(Temperature other) {
    return Temperature.celsius(_celsius + other._celsius);
  }

  /// Subtracts one temperature from another and returns a new Temperature.
  Temperature operator -(Temperature other) {
    return Temperature.celsius(_celsius - other._celsius);
  }

  /// Multiplies the temperature by a factor and returns a new Temperature.
  Temperature operator *(num factor) {
    return Temperature.celsius(_celsius * factor);
  }

  /// Divides the temperature by a quotient and returns a new Temperature.
  Temperature operator /(num quotient) {
    if (quotient == 0) throw UnsupportedError('Cannot divide by zero');
    return Temperature.celsius(_celsius / quotient);
  }

  /// Comparison operators.
  bool operator <(Temperature other) => _celsius < other._celsius;
  bool operator >(Temperature other) => _celsius > other._celsius;
  bool operator <=(Temperature other) => _celsius <= other._celsius;
  bool operator >=(Temperature other) => _celsius >= other._celsius;

  @override
  bool operator ==(Object other) =>
      other is Temperature && _celsius == other._celsius;

  @override
  int get hashCode => _celsius.hashCode;

  @override
  int compareTo(Temperature other) => _celsius.compareTo(other._celsius);

  @override
  String toString() => '${_celsius.toStringAsFixed(2)}°C';

  /// Returns the absolute value of the temperature.
  Temperature abs() => Temperature.celsius(_celsius.abs());

  /// Negates the temperature (reverses its sign).
  Temperature operator -() => Temperature.celsius(-_celsius);
}
