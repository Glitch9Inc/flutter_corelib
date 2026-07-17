import 'dart:async';

import 'package:logging/logging.dart';

/// interval로 세팅된 시간마다 리퀘스트를 보낸 시점으로부터 몇 초가 지났는지 로그를 남기는 클래스
class HttpRequestTimer {
  final int interval;
  final String? requestName;
  final Logger _logger;

  Timer? _timer;
  int _startTime = 0;

  HttpRequestTimer(this.interval, {this.requestName, Logger? logger})
      : _logger = logger ?? Logger('HttpRequestTimer') {
    if (interval <= 0) {
      throw ArgumentError.value(interval, 'interval', 'Must be positive');
    }
  }

  bool get isRunning => _timer?.isActive ?? false;

  void start() {
    _timer?.cancel();
    _startTime = DateTime.now().millisecondsSinceEpoch;
    _timer = Timer.periodic(Duration(seconds: interval), _logElapsedTime);
  }

  void _logElapsedTime(Timer timer) {
    final elapsed = DateTime.now().millisecondsSinceEpoch - _startTime;
    final elapsedSec = elapsed ~/ 1000;
    _logger.info(_resolveLogText(elapsedSec));
  }

  String _resolveLogText(int elapsedSec) {
    String reqName = requestName ?? 'HttpRequest';
    return '$reqName request took $elapsedSec seconds...';
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
