import 'package:flutter_corelib/flutter_corelib.dart';
import 'base_cache_collection.dart';

class CacheMap<TKey, TValue> extends BaseCacheCollection<TKey, TValue> {
  final RxMap<TKey, TValue?> _cachedData = <TKey, TValue?>{}.obs; // 반응형 변수로 캐시 데이터를 관리
  Map<TKey, TValue?> get cachedData => _cachedData;

  @override
  bool isCached(TKey key) => _cachedData.containsKey(key);

  bool containsKey(TKey key) => _cachedData.containsKey(key);

  @override
  TValue? get(TKey key) => _cachedData[key];

  @override
  void set(TKey key, TValue? value) => _cachedData[key] = value;

  void setMap(Map<TKey, TValue?> value) {
    _cachedData.clear();
    _cachedData.addAll(value);
  }

  List<TValue?>? toList() {
    return _cachedData.values.toList();
  }

  @override
  void remove(TKey key) => _cachedData.remove(key);
}
