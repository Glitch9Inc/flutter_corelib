abstract class EnumUtil {
  static T parseString<T extends Enum>(
      String? value, List<T> values, T defaultValue) {
    if (value == null) return defaultValue;
    return values.firstWhere((element) => element.toString() == value,
        orElse: () => defaultValue);
  }

  static T parseInt<T extends Enum>(
      int? value, List<T> values, T defaultValue) {
    if (value == null) return defaultValue;
    return values.firstWhere((element) => element.index == value,
        orElse: () => defaultValue);
  }

  static String stringify<T extends Enum>(T value) {
    return value.toString().split('.').last;
  }
}
