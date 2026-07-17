import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../utils/discord.dart';

enum LogLevel {
  minimal,
  verbose,
}

class LogData {
  final String message;
  final String level;

  const LogData(this.message, this.level);

  factory LogData.fromStream(dynamic data) {
    return LogData(data['message'] as String, data['level'] as String);
  }
}

/// Small compatibility facade over package:logging.
///
/// Initialization is idempotent, retained records use a bounded ring buffer,
/// and external reporting is disabled until the application injects a reporter.
abstract class Debug {
  static const int maxRetainedLogs = 500;
  static const LogLevel logLevel = LogLevel.minimal;

  static Logger logger = Logger('DEBUG');
  static ErrorReporter? errorReporter;

  static final List<LogData> _logs = <LogData>[];
  static StreamSubscription<LogRecord>? _logSubscription;
  static FlutterExceptionHandler? _previousFlutterErrorHandler;

  static List<LogData> getLogs() => List<LogData>.unmodifiable(_logs);

  static void info(String message) => logger.info(message);

  static void json(String jsonString) {
    logger.info(_formatJsonToReadableLog(jsonString));
  }

  static void warning(String message) => logger.warning(message);

  static void fine(String message) => logger.fine(message);

  static void severe(
    Object message, {
    bool sendToDiscord = false,
    Object? error,
    StackTrace? stackTrace,
  }) {
    logger.severe(message.toString(), error, stackTrace);
    final reporter = errorReporter;
    if (sendToDiscord && reporter != null) {
      unawaited(
        reporter
            .report(
          _redact(message.toString()),
          error: error == null ? null : _redact(error.toString()),
          stackTrace: stackTrace,
        )
            .catchError((Object reportError, StackTrace reportStack) {
          logger.warning(
            'External error reporter failed',
            reportError,
            reportStack,
          );
        }),
      );
    }
  }

  static void shout(String message) => logger.shout(message);

  static void addLog(String message) => _retain(LogData(message, 'INFO'));

  static void ensureInitialized({Level level = Level.ALL}) {
    if (_logSubscription != null) return;

    Logger.root.level = level;
    _logSubscription = Logger.root.onRecord.listen((LogRecord record) {
      final rawLog = record.loggerName.isEmpty
          ? record.message
          : '[${record.loggerName}] ${record.message}';
      _retain(LogData(_redact(rawLog), record.level.name));
      if (kDebugMode) {
        debugPrint(_formatLog(record));
      }
    });

    _previousFlutterErrorHandler = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      logger.severe(
        details.exceptionAsString(),
        details.exception,
        details.stack,
      );

      final previous = _previousFlutterErrorHandler;
      if (previous != null) {
        previous(details);
      } else if (logLevel == LogLevel.verbose || kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
  }

  static Future<void> dispose() async {
    final subscription = _logSubscription;
    _logSubscription = null;
    await subscription?.cancel();

    if (FlutterError.onError != _previousFlutterErrorHandler) {
      FlutterError.onError = _previousFlutterErrorHandler;
    }
    _previousFlutterErrorHandler = null;
  }

  static void setUsername(String username) {
    logger = Logger(username);
  }

  static Color getTextColor(String level) {
    switch (level) {
      case 'INFO':
        return Colors.green;
      case 'WARNING':
        return Colors.orange;
      case 'SEVERE':
        return Colors.red;
      case 'FINE':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  static void _retain(LogData log) {
    if (_logs.length == maxRetainedLogs) {
      _logs.removeAt(0);
    }
    _logs.add(log);
  }

  static String _formatJsonToReadableLog(String value) {
    try {
      final decoded = jsonDecode(value);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } on FormatException {
      return value;
    }
  }

  static String _formatLog(LogRecord record) {
    final name = record.loggerName.isEmpty ? '' : '[${record.loggerName}] ';
    return '${record.level.name}: $name${_redact(record.message)}';
  }

  static String _redact(String value) {
    var redacted = value;
    const sensitiveKeys = <String>[
      'authorization',
      'cookie',
      'password',
      'token',
      'api_key',
      'apikey',
    ];
    for (final key in sensitiveKeys) {
      redacted = redacted.replaceAll(
        RegExp(
          '($key\\s*[:=]\\s*)([^\\s,;]+)',
          caseSensitive: false,
        ),
        r'$1<redacted>',
      );
    }
    return redacted;
  }
}
