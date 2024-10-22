abstract class ParseEnum {
  static T fromString<T extends Enum>(String? value, List<T> values, [T? defaultValue]) {
    if (value == null) return defaultValue ?? values.first;
    return values.firstWhere((element) => element.toString() == value, orElse: () => defaultValue ?? values.first);
  }

  static T fromInt<T extends Enum>(int? value, List<T> values, T defaultValue) {
    if (value == null) return defaultValue;
    return values.firstWhere((element) => element.index == value, orElse: () => defaultValue);
  }

  static String stringify<T extends Enum>(T value) {
    return value.toString().split('.').last;
  }
}
