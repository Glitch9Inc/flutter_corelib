import 'dart:math';

extension ListExt on List {
  T random<T>() {
    if (isEmpty) {
      throw Exception('List is empty');
    }
    return this[Random().nextInt(length)];
  }
}

extension NullableListExt on List? {
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;
}
