import 'dart:convert';

import 'package:dio/dio.dart';

/// Optional destination for application error reports.
///
/// Core logging never installs a reporter by default. Applications must opt in
/// by constructing an implementation with runtime configuration.
abstract interface class ErrorReporter {
  Future<void> report(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  });
}

/// Discord webhook adapter configured by the application at runtime.
///
/// Do not put webhook URLs in source code. Inject them from an application
/// secret/configuration provider.
class Discord implements ErrorReporter {
  final Uri webhookUri;
  final Dio _dio;

  // Deliberately a bare Dio, not DioUtil.createDio(): a Discord webhook keeps
  // its secret token in the URL path, and DioLogInterceptor only redacts query
  // parameters, so logging this client would write the token to the log.
  Discord({
    required String webhookUrl,
    Dio? dio,
  })  : webhookUri = _validateWebhookUrl(webhookUrl),
        _dio = dio ?? Dio();

  static Uri _validateWebhookUrl(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host != 'discord.com' ||
        !uri.path.startsWith('/api/webhooks/')) {
      throw ArgumentError.value(value, 'webhookUrl', 'Invalid Discord webhook');
    }
    return uri;
  }

  @override
  Future<void> report(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) async {
    final content = StringBuffer(message);
    if (error != null) content.write('\n$error');
    if (stackTrace != null) content.write('\n$stackTrace');

    final response = await _dio.post<void>(
      webhookUri.toString(),
      options: Options(headers: const <String, String>{
        'Content-Type': 'application/json',
      }),
      data: jsonEncode(<String, String>{
        'content': _truncate(content.toString(), 1900),
      }),
    );

    if (response.statusCode != 204) {
      throw StateError(
        'Discord webhook returned status ${response.statusCode}',
      );
    }
  }

  @Deprecated('Use report(message).')
  Future<void> sendMessage(String message) => report(message);

  static String _truncate(String value, int maxLength) {
    if (value.length <= maxLength) return value;
    return '${value.substring(0, maxLength - 1)}…';
  }
}
