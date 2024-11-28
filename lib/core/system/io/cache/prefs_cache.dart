import 'package:flutter_corelib/flutter_corelib.dart';

/// Property나 Field의 캐시 관리를 쉽게하기 위한 클래스
/// 캐시된 시간을 쉽게 관리할 수 있도록 하기 위해 만들어진 클래스
class PrefsCache<T> {
  final String key;
  final T? defaultValue;
  Expiration expiration;
  T? _value;

  T? get value {
    if (isExpired()) return defaultValue;
    return _value ?? defaultValue;
  }

  set value(T? value) {
    _value = value;
    _lastCachedAt = DateTime.now();

    if (_value != null) {
      PlayerPrefs.set<T>(key, _value!);
      PlayerPrefs.setDateTime('$key.lastCachedAt', _lastCachedAt);
    }

    if (isExpired()) expiration.extend();
  }

  late DateTime _lastCachedAt;
  DateTime get lastCachedAt => _lastCachedAt;

  /// 캐시된 값이 있는지 확인
  bool get isCached => _value != null;

  PrefsCache(
    this.key, {
    required this.expiration,
    this.defaultValue,
  }) {
    _value = PlayerPrefs.get<T>(key);
    _lastCachedAt = PlayerPrefs.getDateTime('$key.lastCachedAt') ?? DateTime.now();
  }

  // 오늘 24시가 지나면 만료된다고 판단
  static PrefsCache<T> expiresToday<T>(
    String key, {
    T? defaultValue,
  }) {
    return PrefsCache<T>(
      key,
      expiration: Expiration.expiresToday(),
      defaultValue: defaultValue,
    );
  }

  bool isExpired() => expiration.isExpired();
}
