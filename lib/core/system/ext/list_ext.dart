import 'dart:math';

extension ListExt on List {
  T? random<T>() {
    if (isEmpty) return null;
    return this[Random().nextInt(length)];
  }
}

extension NullableListExt on List? {
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;
}
