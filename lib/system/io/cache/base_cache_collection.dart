abstract class BaseCacheCollection<TKey, TValue> {
  bool isCached(TKey key);
  TValue? get(TKey key);
  void set(TKey key, TValue? value);
  void remove(TKey key);
}
