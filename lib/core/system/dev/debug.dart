import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

import 'discord.dart';

const bool kDebugMode = true;
const LogLevel kLogLevel = LogLevel.minimal;

enum LogLevel {
  minimal,
  verbose,
}

class LogData {
  final String message;
  final String level;
  LogData(this.message, this.level);

  factory LogData.fromStream(dynamic data) {
    return LogData(data['message'], data['level']);
  }
}

/// 유니티 스타일 로거
/// 'Debug'라는 이름의 글로벌 로거를 만들어서 사용한다.
abstract class Debug {
  static Logger logger = Logger("DEBUG");
  static Discord discord = Discord();

  static final List<LogData> logs = [];
  static List<LogData> getLogs() => logs;

  static void info(String message) {
    logger.info(message);
  }

  static void warning(String message) {
    logger.warning(message);
  }

  static void fine(String message) {
    logger.fine(message);
  }

  static void severe(Object message) {
    logger.severe(message);
  }

  static void shout(String message) {
    logger.shout(message);
  }

  static void addLog(String message) {
    logs.add(LogData(message, "INFO"));
  }

  static void init() {
    Logger.root.level = Level.ALL; // 로그 레벨 설정
    Logger.root.onRecord.listen((LogRecord rec) {
      // ignore: avoid_print
      if (kDebugMode) print(_formatLog(rec));
    });
    _customizeFlutterErrorMessage();
  }

  static void setUsername(String username) {
    logger = Logger(username);
  }

  static void _customizeFlutterErrorMessage() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kLogLevel == LogLevel.verbose) {
        // 전체 에러는 디버그 빌드에서만 출력
        FlutterError.dumpErrorToConsole(details);
      } else {
        // 짧은 에러메시지를 출력한다. 빨간색으로 출력하여야 한다.
        _printShortError(details);
      }
    };
  }

  static void _printShortError(FlutterErrorDetails details) {
    print('====== Exception caught by Flutter Error Handler ======'.red);
    print('${details.exceptionAsString().red}');
    print('${details.stack.toString().red}');
    print('========================================================'.red);
  }

  static String _formatLog(LogRecord rec) {
    final StringBuffer buffer = StringBuffer();
    switch (rec.level.name) {
      case 'INFO': // Green
        buffer.write('\x1B[32m');
        break;
      case 'WARNING': // Yellow
        buffer.write('\x1B[33m');
        break;
      case 'SEVERE': // Red
        buffer.write('\x1B[31m');
        discord.sendMessage(rec.message);
        break;
      case 'FINE': // Magenta
        buffer.write('\x1B[35m');
        break;
      case 'SHOUT': // Cyan
        buffer.write('\x1B[36m');
        break;
      case 'CONFIG': // Bright Green
        buffer.write('\x1B[92m');
        break;
      default: // Default color
        buffer.write('\x1B[0m');
        break;
    }
    String rawLog;

    if (rec.loggerName.isEmpty) {
      rawLog = rec.message;
    } else {
      rawLog = '[${rec.loggerName}] ${rec.message}';
    }

    buffer.write(rawLog);
    buffer.write('\x1B[0m'); // Reset color
    String log = buffer.toString();

    logs.add(LogData(rawLog, rec.level.name));
    return log;
  }

  static Color getTextColor(String level) {
    switch (level) {
      case 'INFO':
        return Colors.green;
      case 'WARNING':
        return Colors.yellow;
      case 'SEVERE':
        return Colors.red;
      case 'FINE':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}
