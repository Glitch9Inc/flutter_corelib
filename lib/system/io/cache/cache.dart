import 'package:flutter_corelib/system/models/expiration.dart';

/// Property나 Field의 캐시 관리를 쉽게하기 위한 클래스
/// 캐시된 시간을 쉽게 관리할 수 있도록 하기 위해 만들어진 클래스
class Cache<T> {
  final T defaultValue;

  /// 현재 캐시값이 업데이트되면 같이 업데이트되어야 하는 캐시들
  final List<Cache>? _linkedValues;
  Expiration? expiration;

  T? _value;

  T get value {
    if (isExpired()) return defaultValue;
    return _value ?? defaultValue;
  }

  set value(T value) {
    _value = value;
    _lastCachedAt = DateTime.now();
    requiresUpdate = false;

    if (isExpired()) expiration?.extend();
    if (_linkedValues != null) {
      for (var linkedValue in _linkedValues) {
        linkedValue.requiresUpdate = true;
      }
    }
  }

  DateTime _lastCachedAt;
  DateTime get lastCachedAt => _lastCachedAt;

  /// 캐시된 값이 있는지 확인
  bool get isCached => _value != null;

  /// 외부에서 bool값 추가없이 갱싱여부를 확인하기 위한 변수
  bool requiresUpdate = false;

  Cache(
    this.defaultValue, {
    T? value,
    DateTime? cachedTime,
    this.expiration,
    List<Cache>? linkedValues,
  })  : _value = value,
        _lastCachedAt = cachedTime ?? DateTime.now(),
        _linkedValues = linkedValues;

  // 오늘 24시가 지나면 만료된다고 판단
  factory Cache.expiresToday(
    T defaultValue, {
    T? value,
    DateTime? cachedTime,
    List<Cache>? linkedValues,
  }) {
    return Cache(
      defaultValue,
      value: value,
      cachedTime: cachedTime,
      expiration: Expiration.expiresToday(),
      linkedValues: linkedValues,
    );
  }

  bool isExpired() {
    if (expiration == null) return false;
    return expiration!.isExpired();
  }
}
