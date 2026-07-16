extension EnumExt on Enum {
  String stringify() {
    return toString().split('.').last;
  }
}

extension EnumListExt on List<Enum> {
  List<T> removeFirst<T extends Enum>() {
    // copy the list because the original list is unmodifiable
    final List<T> copy = List<T>.from(this);
    copy.removeAt(0);
    return copy;
  }

  List<T> removeLast<T extends Enum>() {
    // copy the list because the original list is unmodifiable
    final List<T> copy = List<T>.from(this);
    copy.removeAt(copy.length - 1);
    return copy;
  }

  List<String> stringifyList() {
    return map((e) => e.toString().split('.').last).toList();
  }
}
