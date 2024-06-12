// 유니티랑 비슷하게 디버그 로그를 출력하는 클래스
// ignore_for_file: avoid_print
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

export 'log_level.dart';

enum LogType {
  info,
  warning,
  error,
}

enum LogStyle {
  none,
  asciiArt,
}

class LogData {
  final LogType type;
  final String message;
  LogData(this.type, this.message);
}

@protected
@immutable
class Debug {
  // ANSI escape codes for terminal colors
  static const String _blue = '\x1B[34m';
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';
  static const String _default = '\x1B[39m';

  static const String _asciiTop =
      '┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────';
  static const String _asciiMid = '|  ';
  static const String _asciiBot =
      '└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────';

  static final List<LogData> logs = [];
  static Function(LogData log)? uiCallback;

  static void log(
    String message, {
    String? tag,
    bool stackTrace = false,
    bool callUI = false,
    LogStyle style = LogStyle.none,
  }) {
    String messageWithTag = _addTag(tag, message);
    if (kDebugMode) {
      _printLog(messageWithTag, style, stackTrace);
      logs.add(LogData(LogType.info, messageWithTag));
    }
    if (callUI) {
      uiCallback?.call(LogData(LogType.info, messageWithTag));
    }
  }

  static void logWarning(
    String message, {
    String? tag,
    bool stackTrace = false,
    bool callUI = false,
    LogStyle style = LogStyle.none,
  }) {
    String messageWithTag = _addTag(tag, message);
    if (kDebugMode) {
      _printWarning(messageWithTag, style, stackTrace);
      logs.add(LogData(LogType.warning, messageWithTag));
    }
    if (callUI) {
      uiCallback?.call(LogData(LogType.warning, messageWithTag));
    }
  }

  static void logError(
    String message, {
    String? tag,
    bool stackTrace = false,
    bool callUI = false,
    LogStyle style = LogStyle.none,
  }) {
    String messageWithTag = _addTag(tag, message);
    if (kDebugMode) {
      _printError(messageWithTag, style, stackTrace);
      logs.add(LogData(LogType.error, messageWithTag));
    }
    if (callUI) {
      uiCallback?.call(LogData(LogType.error, messageWithTag));
    }
  }

  static void logException(Object e,
      {String? tag, bool stackTrace = false, bool callUI = false, LogStyle style = LogStyle.none}) {
    if (e is! Exception) return;
    String messageWithTag = _addTag(tag, e.toString());
    if (kDebugMode) {
      _printError(messageWithTag, style, stackTrace);
      logs.add(LogData(LogType.error, messageWithTag));
    }
    if (callUI) {
      uiCallback?.call(LogData(LogType.error, messageWithTag));
    }
  }

  static void _printLog(String message, LogStyle style, bool stackTrace) {
    if (style == LogStyle.asciiArt) {
      String coloredMessage = _tintMessage(message, _blue);
      dev.log(_asciiTop);
      dev.log(_asciiMid + coloredMessage);
      if (stackTrace) _printStackTrace(LogType.info, style);
      dev.log(_asciiBot);
    } else {
      dev.log(message);
      if (stackTrace) _printStackTrace(LogType.info, style);
    }
  }

  static void _printWarning(String message, LogStyle style, bool stackTrace) {
    String coloredMessage = _tintMessage(message, _yellow);
    if (style == LogStyle.asciiArt) {
      dev.log(_asciiTop);
      dev.log(_asciiMid + coloredMessage);
      if (stackTrace) _printStackTrace(LogType.warning, style);
      dev.log(_asciiBot);
    } else {
      dev.log(coloredMessage);
      if (stackTrace) _printStackTrace(LogType.warning, style);
    }
  }

  static void _printError(String message, LogStyle style, bool stackTrace) {
    String coloredMessage = _tintMessage(message, _red);
    if (style == LogStyle.asciiArt) {
      dev.log(_asciiTop);
      dev.log(_asciiMid + coloredMessage);
      if (stackTrace) _printStackTrace(LogType.error, style);
      dev.log(_asciiBot);
    } else {
      dev.log(coloredMessage);
      if (stackTrace) _printStackTrace(LogType.error, style);
    }
  }

  static void _printStackTrace(LogType type, LogStyle style) {
    StackTrace stackTrace = StackTrace.current;
    final traceString = stackTrace.toString().split('\n')[1];
    final indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z]+.dart'));
    final fileInfo = traceString.substring(indexOfFileName);
    final fileName = fileInfo.split(':')[0];
    final lineNumber = fileInfo.split(':')[1];
    final columnNumber = fileInfo.split(':')[2].split(')')[0];
    String color = _getTintColor(type);

    if (style == LogStyle.asciiArt) {
      dev.log(_tintMessage('${_asciiMid}File: $fileName', color));
      dev.log(_tintMessage('${_asciiMid}Line: $lineNumber', color));
      dev.log(_tintMessage('${_asciiMid}Column: $columnNumber', color));
    } else {
      dev.log(_tintMessage('File: $fileName', color));
      dev.log(_tintMessage('Line: $lineNumber', color));
      dev.log(_tintMessage('Column: $columnNumber', color));
    }
  }

  static String _addTag(String? tag, String message) {
    return tag == null ? message : '[$tag] $message';
  }

  static String _getTintColor(LogType type) {
    switch (type) {
      case LogType.info:
        return _blue;
      case LogType.warning:
        return _yellow;
      case LogType.error:
        return _red;
    }
  }

  static String _tintMessage(String message, String color) {
    return '$color$message$_default';
  }
}
