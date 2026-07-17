import 'dart:async';

import 'package:dart_corelib/cache/cache.dart';

import '../../prefs/flutter_prefs.dart';

class PrefsCache<T> {
  final String key;
  final T? defaultValue;
  Expiration expiration;
  T? _value;
  late DateTime _lastCachedAt;

  PrefsCache(
    this.key, {
    required this.expiration,
    this.defaultValue,
  }) {
    _value = FlutterPrefs.get<T>(key);
    _lastCachedAt =
        FlutterPrefs.getDateTime('$key.lastCachedAt') ?? DateTime.now();
    if (_value != null) {
      expiration = Expiration(
        expiration.duration,
        expirationTime: _lastCachedAt.add(expiration.duration),
      );
    }
  }

  factory PrefsCache.expiresToday(
    String key, {
    T? defaultValue,
  }) {
    return PrefsCache<T>(
      key,
      expiration: Expiration.expiresToday(),
      defaultValue: defaultValue,
    );
  }

  T? get value => isExpired() ? defaultValue : (_value ?? defaultValue);

  set value(T? value) {
    unawaited(setValue(value));
  }

  DateTime get lastCachedAt => _lastCachedAt;
  bool get isCached => _value != null && !isExpired();

  Future<void> setValue(T? value) async {
    _value = value;
    _lastCachedAt = DateTime.now();
    expiration.extend();

    if (value == null) {
      await Future.wait(<Future<void>>[
        FlutterPrefs.remove(key),
        FlutterPrefs.remove('$key.lastCachedAt'),
      ]);
      return;
    }

    await Future.wait(<Future<void>>[
      FlutterPrefs.set<T>(key, value),
      FlutterPrefs.setDateTime('$key.lastCachedAt', _lastCachedAt),
    ]);
  }

  Future<void> clear() => setValue(null);

  bool isExpired() => expiration.isExpired();
}
