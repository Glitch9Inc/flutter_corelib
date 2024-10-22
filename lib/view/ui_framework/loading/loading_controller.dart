import 'dart:async';

import 'package:get/get.dart';

import 'loading.dart';

abstract class LoadingControllerBase {
  String get message;
  double get percentage;
  final bool autoClose;
  final RxBool isCompleted = false.obs;

  LoadingControllerBase({this.autoClose = true});

  void complete() {
    isCompleted.value = true;
    if (autoClose) {
      Loading.hide(force: true);
    }
  }
}

class ManualLoadingController extends LoadingControllerBase {
  final List<String> entries;
  final RxInt currentMessageIndex = 0.obs;

  ManualLoadingController({
    required this.entries,
    super.autoClose = true,
  });

  @override
  String get message => entries[currentMessageIndex.value];

  @override
  double get percentage => currentMessageIndex.value / entries.length;

  void next() {
    currentMessageIndex.value = (currentMessageIndex.value + 1) % entries.length;
    print('ManualLoadingController: ${currentMessageIndex.value}');
    if (currentMessageIndex.value == 0) {
      complete();
    }
  }
}

class TimeBasedLoadingController extends LoadingControllerBase {
  final Duration duration;
  final RxString _loadingMessage = 'Now loading...'.obs;
  final RxDouble _percentage = 0.0.obs;
  final bool autoComplete;
  Timer? _timer;

  TimeBasedLoadingController(
    this.duration, {
    String? initialMessage,
    bool startImmediately = true,
    this.autoComplete = true,
    super.autoClose = true,
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
        if (autoComplete) {
          complete();
        }
      }

      print('총 로딩시간: ${duration.inMilliseconds}ms, 현재 퍼센티지: ${_percentage.value}');
    });
  }

  void setMessage(String message) {
    _loadingMessage.value = message;
  }
}
