extension SetExt on Set {
  bool has(String flag) => contains(flag);

  bool toggle(String flag, [bool? value]) {
    if (value == null) {
      if (has(flag)) {
        remove(flag);
        return false;
      } else {
        add(flag);
        return true;
      }
    } else {
      if (value) {
        if (has(flag)) {
          print('Already has $flag');
          return true;
        }
        add(flag);
        return true;
      } else {
        if (!has(flag)) {
          print('Already does not have $flag');
          return false;
        }
        remove(flag);
        return false;
      }
    }
  }
}
