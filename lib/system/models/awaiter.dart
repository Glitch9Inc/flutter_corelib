import 'dart:async';

abstract class Awaiter {
  static Future<void> waitUntil(
    bool Function() condition, {
    Duration interval = const Duration(milliseconds: 500),
    Duration timeout = const Duration(seconds: 30),
  }) {
    if (interval <= Duration.zero) {
      throw ArgumentError.value(interval, 'interval', 'Must be positive');
    }
    if (timeout <= Duration.zero) {
      throw ArgumentError.value(timeout, 'timeout', 'Must be positive');
    }
    if (condition()) return Future<void>.value();

    final completer = Completer<void>();
    Timer? pollTimer;
    Timer? timeoutTimer;

    void finish([Object? error, StackTrace? stackTrace]) {
      pollTimer?.cancel();
      timeoutTimer?.cancel();
      if (completer.isCompleted) return;
      if (error == null) {
        completer.complete();
      } else {
        completer.completeError(error, stackTrace);
      }
    }

    pollTimer = Timer.periodic(interval, (_) {
      try {
        if (condition()) finish();
      } on Object catch (error, stackTrace) {
        finish(error, stackTrace);
      }
    });
    timeoutTimer = Timer(
      timeout,
      () => finish(
        TimeoutException('Condition was not met within $timeout', timeout),
      ),
    );

    return completer.future;
  }
}
