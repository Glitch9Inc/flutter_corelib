import 'dart:async';

import 'package:get/get.dart';

abstract class LoadingController {
  String get message;
  double get percentage;
}

class ManualLoadingController extends LoadingController {
  final List<String> loadingMessages;
  RxInt currentMessageIndex = 0.obs;

  ManualLoadingController(this.loadingMessages);

  @override
  String get message => loadingMessages[currentMessageIndex.value];

  @override
  double get percentage => currentMessageIndex.value / loadingMessages.length;

  void next() {
    currentMessageIndex.value = (currentMessageIndex.value + 1) % loadingMessages.length;
  }
}

class TimeBasedLoadingController extends LoadingController {
  final Duration duration;
  final RxString _loadingMessage = 'Now loading...'.obs;
  final RxDouble _percentage = 0.0.obs;
  Timer? _timer;

  TimeBasedLoadingController(
    this.duration, {
    String? initialMessage,
    bool startImmediately = true,
  }) {
    if (initialMessage != null) {
      _loadingMessage.value = initialMessage;
    }

    if (startImmediately) {
      start();
    }
  }

  @override
  String get message => _loadingMessage.value;

  @override
  double get percentage => _percentage.value;

  void start() {
    _percentage.value = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      // 퍼센티지를 0 ~ 1 범위로 증가
      _percentage.value += 1 / (duration.inMilliseconds / 100);

      // 퍼센티지가 1.0 이상일 경우 타이머 취소
      if (_percentage.value >= 1.0) {
        _timer?.cancel();
        _percentage.value = 1.0; // 최대값 1.0으로 설정
      }

      print('총 로딩시간: ${duration.inMilliseconds}ms, 현재 퍼센티지: ${_percentage.value}');
    });
  }

  void setMessage(String message) {
    _loadingMessage.value = message;
  }
}
