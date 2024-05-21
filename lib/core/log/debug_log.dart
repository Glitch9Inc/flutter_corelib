//유니티랑 비슷하게 디버그 로그를 출력하는 클래스
import 'package:flutter/foundation.dart';

enum LogType {
  info,
  warning,
  error,
}

class LogData {
  final LogType type;
  final String message;
  LogData(this.type, this.message);
}

class Debug {
  // ANSI escape codes for terminal colors
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';
  static const String _default = '\x1B[39m';
  static final List<LogData> logs = [];

  static void log(String message) {
    if (kDebugMode) {
      print(message);
      logs.add(LogData(LogType.info, message));
    }
  }

  static void logWarning(String message) {
    if (kDebugMode) {
      print('$_yellow$message$_default');
      logs.add(LogData(LogType.warning, message));
    }
  }

  static void logError(String message) {
    if (kDebugMode) {
      print('$_red$message$_default');
      logs.add(LogData(LogType.error, message));
    }
  }
}
