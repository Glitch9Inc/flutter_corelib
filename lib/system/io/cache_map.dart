import 'package:flutter_corelib/flutter_corelib.dart';

class CacheMap<TKey, TValue> extends CacheCollection<TKey, TValue> {
  final _cachedData = <TKey, TValue?>{}.obs; // 반응형 변수로 캐시 데이터를 관리
  Map<TKey, TValue?> get cachedData => _cachedData;

  int get length => _cachedData.length;

  @override
  bool isCached(TKey key) => _cachedData.containsKey(key);

  bool containsKey(TKey key) => _cachedData.containsKey(key);

  @override
  TValue? get(TKey key) => _cachedData[key];

  @override
  void set(TKey key, TValue? value) => _cachedData[key] = value;

  @override
  void setEmpty(TKey key) => _cachedData[key] = null;

  void setMap(Map<TKey, TValue?> value) {
    _cachedData.clear();
    _cachedData.addAll(value);
  }

  List<TValue> toList() {
    // null이 아닌 값만 리스트로 반환
    return _cachedData.values.whereType<TValue>().toList();
  }

  @override
  void remove(TKey key) => _cachedData.remove(key);
}
