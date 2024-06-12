import 'package:flutter_corelib/flutter_corelib.dart';

class Logger {
  final String _tag;
  bool isActive = true;

  Logger(this._tag);

  void info(String message) {
    if (!isActive) return;
    Debug.log(message, tag: _tag);
  }

  void warning(String message) {
    if (!isActive) return;
    Debug.logWarning(message, tag: _tag);
  }

  void error(String message) {
    if (!isActive) return;
    Debug.logError(message, tag: _tag);
  }

  void exception(Object e, {bool stackTrace = false}) {
    if (!isActive) return;
    Debug.logException(e, tag: _tag, stackTrace: stackTrace);
  }
}
