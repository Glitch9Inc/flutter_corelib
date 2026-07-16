abstract class EnumConverter {
  static int enumToIndex<TEnum extends Enum>(TEnum value) {
    return value.index;
  }

  static TEnum indexToEnum<TEnum extends Enum>(int value, List<TEnum> values) {
    return values[value];
  }

  static int enumListToFlag<TEnum extends Enum>(List<TEnum> values) {
    return values.map((TEnum value) => value.index).reduce((int a, int b) => a | b);
  }

  static List<TEnum> flagToEnumList<TEnum extends Enum>(int value, List<TEnum> values) {
    final List<TEnum> result = [];
    for (int i = 0; i < values.length; i++) {
      if ((value & (1 << i)) != 0) {
        result.add(values[i]);
      }
    }
    return result;
  }
}
