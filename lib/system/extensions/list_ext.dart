import 'dart:math';

extension ListExt on List {
  T? random<T>() {
    if (isEmpty) return null;
    return this[Random().nextInt(length)];
  }

  List<T> removeFromList<T>(List<T> items) {
    return List.from(this)..removeWhere((element) => items.contains(element));
  }

  T? getOrNull<T>(int index) {
    if (index < 0 || index >= length) return null;
    final item = this[index];
    if (item is T) return item;
    return null;
  }

  bool containsAll<T>(List<T> items) {
    return items.every((element) => contains(element));
  }
}

extension NullableListExt on List? {
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;
}
