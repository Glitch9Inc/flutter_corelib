import 'package:flutter_corelib/flutter_corelib.dart';
import 'base_cache_collection.dart';
import 'cache_list_mixin.dart';

class CacheListMap<TKey, TValue> extends BaseCacheCollection<TKey, TValue> with CacheListMixin<TValue> {
  final RxMap<TKey, RxList<TValue?>> _cachedData = <TKey, RxList<TValue?>>{}.obs;
  Map<TKey, List<TValue?>> get cachedData => _cachedData;

  @override
  bool isCached(TKey key) => _cachedData.containsKey(key);

  @override
  TValue? get(TKey key, {int index = 0}) => _cachedData[key]?[index];

  @override
  void set(TKey key, TValue? value, {int index = 0}) {
    _cachedData.putIfAbsent(key, () => <TValue?>[].obs)[index] = value;
  }

  @override
  void remove(TKey key, {int index = 0}) => _cachedData[key]?[index] = null;

  @override
  List<TValue?> getList({TKey? key}) {
    if (key == null) throw ArgumentError.notNull('key');
    return _cachedData[key] ?? [];
  }

  @override
  void setList(List<TValue?> value, {TKey? key}) {
    if (key == null) throw ArgumentError.notNull('key');
    _cachedData[key] = value.obs;
  }
}
