import 'dart:async';

import 'package:flutter_corelib/flutter_corelib.dart';

/// interval로 세팅된 시간마다 리퀘스트를 보낸 시점으로부터 몇 초가 지났는지 로그를 남기는 클래스
class HttpRequestTimer {
  final int interval;
  final String? requestName;
  Timer? _timer;
  Logger _logger;
  int _startTime = 0;

  HttpRequestTimer(this.interval, {this.requestName, Logger? logger}) : _logger = logger ?? Logger('HttpRequestTimer');

  void start() {
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
  }
}
