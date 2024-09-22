import 'package:flutter_corelib/flutter_corelib.dart';

Future<void> openUrl(String url) async {
  Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $uri');
  }
}

// define 'Function(Object e, StackTrace s)' as ExceptionHandler
abstract class BaseExceptionHandler {
  void call(Object e, StackTrace s);
}

class ExceptionHandler extends BaseExceptionHandler {
  final Logger _logger;
  ExceptionHandler(String name) : _logger = Logger(name);

  @override
  void call(Object e, StackTrace s) {
    _logger.severe(e, s);
  }
}
