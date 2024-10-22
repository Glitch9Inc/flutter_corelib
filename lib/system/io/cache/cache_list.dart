import 'package:flutter_corelib/flutter_corelib.dart';
import 'base_cache_collection.dart';
import 'cache_list_mixin.dart';

class CacheList<TValue> extends BaseCacheCollection<int, TValue> with CacheListMixin<TValue> {
  final RxList<TValue?> _cachedData = <TValue?>[].obs;

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
  void setList(List<TValue?> value) {
    _cachedData.clear();
    _cachedData.addAll(value);
  }

  @override
  List<TValue?> getList() => _cachedData;

  List<TValue> getNonNullList() => _cachedData.whereType<TValue>().toList();

  @override
  void remove(int key) {
    if (key < _cachedData.length) {
      _cachedData[key] = null;
    }
  }
}
