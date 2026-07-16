extension ObjectExt on Object {
  T getEnum<T>(List<T> values, {T? defaultValue}) {
    return values.firstWhere((element) => element.toString().toLowerCase() == toString().toLowerCase(),
        orElse: () => defaultValue ?? values.first);
  }
}
