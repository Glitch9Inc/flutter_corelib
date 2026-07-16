extension IntMapExt on Map<String, int> {
  Map<String, int> increaseInt(String key, int intToAdd) {
    int current = this[key] ?? 0;
    Map<String, int> value = this;
    value[key] = current + intToAdd;
    return value;
  }

  int getSum() {
    return values.fold(0, (a, b) => a + b);
  }

  int getInt(String key) {
    return this[key] ?? 0;
  }
}
