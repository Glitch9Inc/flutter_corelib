import 'dart:async';

class Awaiter {
  static const Duration _interval = Duration(milliseconds: 500);
  static const Duration _timeOut = Duration(seconds: 30);

  final bool Function() condition;
  final Completer<void> _completer = Completer<void>();

  Awaiter._({required this.condition}) {
    // Start checking the condition periodically
    _checkCondition();
  }

  static Future<void> waitUntil(bool Function() condition) async {
    await Awaiter._(condition: condition).waitForCondition();
  }

  Future<void> waitForCondition() async {
    if (!condition()) {
      await Future.any([
        _completer.future,
        Future.delayed(_timeOut, () {
          if (!_completer.isCompleted) {
            _completer.completeError(TimeoutException('Operation timed out'));
          }
        }),
      ]);
    }
  }

  void _checkCondition() {
    Timer.periodic(_interval, (timer) {
      if (condition()) {
        if (!_completer.isCompleted) {
          _completer.complete();
        }
        timer.cancel(); // Stop checking once condition is met
      }
    });
  }
}
