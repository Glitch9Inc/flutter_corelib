import 'package:flutter_corelib/flutter_corelib.dart';
import 'base_cache_collection.dart';

class DateBasedCacheMap<TKey, TValue> extends BaseCacheCollection<TKey, TValue> {
  final RxMap<TKey, Map<Date, TValue?>> _cachedData = <TKey, Map<Date, TValue?>>{}.obs;
  Map<TKey, Map<Date, TValue?>> get cachedData => _cachedData;
  final String dataName;

  DateBasedCacheMap({required this.dataName});

  /// arg is the date
  @override
  bool isCached(TKey key, {Date? date}) =>
      _cachedData.containsKey(key) && _cachedData[key]!.containsKey(resolveDate(date));

  @override
  TValue? get(TKey key, {Date? date}) => _cachedData[key]?[resolveDate(date)];

  @override
  void set(TKey key, TValue? value, {Date? date}) => _cachedData.putIfAbsent(key, () => {})[resolveDate(date)] = value;

  @override
  void remove(TKey key, {Date? date}) => _cachedData[key]?.remove(resolveDate(date));

  Date resolveDate(Date? date) {
    if (date is Date) {
      return date;
    } else {
      return Date.today();
    }
  }
}
