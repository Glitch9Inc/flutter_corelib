import 'package:flutter_corelib/flutter_corelib.dart';

class CacheList<TValue> extends CacheCollection<int, TValue> {
  final _cachedData = <TValue?>[].obs;

  @override
  bool isCached(int key) => key < _cachedData.length;

  @override
  TValue? get(int key) => _cachedData[key];

  @override
  void set(int key, TValue? value) {
    if (key >= _cachedData.length) {
      _cachedData.length = key + 1;
    }
    _cachedData[key] = value;
  }

  @override
  void setEmpty(int key) {
    if (key >= _cachedData.length) {
      _cachedData.length = key + 1;
    }
    _cachedData[key] = null;
  }

  void setList(List<TValue?> value) {
    _cachedData.clear();
    _cachedData.addAll(value);
  }

  List<TValue?> getList() => _cachedData;

  List<TValue> getNonNullList() => _cachedData.whereType<TValue>().toList();

  @override
  void remove(int key) {
    if (key < _cachedData.length) {
      _cachedData[key] = null;
    }
  }
}
