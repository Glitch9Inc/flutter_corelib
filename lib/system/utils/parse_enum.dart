abstract class ParseEnum {
  static T fromString<T extends Enum>(String? value, List<T> values, [T? defaultValue]) {
    if (value == null) return defaultValue ?? values.first;
    return values.firstWhere((element) => _getEnumName(element) == value, orElse: () => defaultValue ?? values.first);
  }

  static String _getEnumName<T extends Enum>(T value) {
    return value.toString().split('.').last;
  }

  static T fromInt<T extends Enum>(int? value, List<T> values, T defaultValue) {
    if (value == null) return defaultValue;
    return values.firstWhere((element) => element.index == value, orElse: () => defaultValue);
  }

  static String stringify<T extends Enum>(T value) {
    return value.toString().split('.').last;
  }
}
