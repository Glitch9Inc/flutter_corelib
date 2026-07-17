import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'dio_log_level.dart';

class DioLogInterceptor extends Interceptor {
  static const Set<String> _sensitiveKeys = <String>{
    'authorization',
    'proxy-authorization',
    'cookie',
    'set-cookie',
    'password',
    'token',
    'access_token',
    'refresh_token',
    'api_key',
    'apikey',
    // Vendor-specific API key headers (Anthropic, ElevenLabs, OpenAI project).
    'x-api-key',
    'xi-api-key',
    'openai-organization',
  };

  final Logger logger;
  final DioLogLevel logLevel;
  final void Function(int)? errorStatusCodeHandler;
  final int maxBodyLength;

  DioLogInterceptor({
    DioLogLevel? logLevel,
    Logger? logger,
    this.errorStatusCodeHandler,
    this.maxBodyLength = 4096,
  })  : assert(maxBodyLength > 0),
        logLevel = logLevel ?? DioLogLevel(),
        logger = logger ?? Logger('Dio');

  bool isEmptyBody(Object? data) {
    return data == null || data.toString().isEmpty || data.toString() == '{}';
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (logLevel.requestUrl) {
      logger.info('Request [${options.method}] => ${_safeUri(options.uri)}');
    }
    if (logLevel.requestHeader) {
      logger.info('Request headers: ${_redactMap(options.headers)}');
    }
    if (logLevel.requestBody) {
      logger.info(
        isEmptyBody(options.data)
            ? 'Request body is empty'
            : 'Request body: ${_safeBody(options.data)}',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (logLevel.responseUrl) {
      logger.info(
        'Response [${response.statusCode}] => '
        '${_safeUri(response.requestOptions.uri)}',
      );
    }
    if (logLevel.responseBody) {
      logger.info(
        isEmptyBody(response.data)
            ? 'Response body is empty'
            : 'Response body: ${_safeBody(response.data)}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.severe(
      'HTTP error [${err.response?.statusCode}] => '
      '${_safeUri(err.requestOptions.uri)}: ${err.message}',
      err,
      err.stackTrace,
    );
    errorStatusCodeHandler?.call(err.response?.statusCode ?? 0);
    handler.next(err);
  }

  String _safeUri(Uri uri) {
    final query = <String, String>{};
    for (final entry in uri.queryParameters.entries) {
      query[entry.key] = _isSensitive(entry.key) ? '<redacted>' : entry.value;
    }
    return uri
        .replace(queryParameters: query.isEmpty ? null : query)
        .toString();
  }

  Object _redactMap(Map<dynamic, dynamic> value) {
    return value.map<String, Object?>((key, item) {
      final name = key.toString();
      return MapEntry(
        name,
        _isSensitive(name) ? '<redacted>' : _redactValue(item),
      );
    });
  }

  Object? _redactValue(Object? value) {
    if (value is Map<dynamic, dynamic>) return _redactMap(value);
    if (value is Iterable<Object?>) {
      return value.map(_redactValue).toList(growable: false);
    }
    return value;
  }

  String _safeBody(Object? data) {
    final redacted =
        data is Map<dynamic, dynamic> ? _redactMap(data) : data.toString();
    var value = redacted.toString();
    for (final key in _sensitiveKeys) {
      value = value.replaceAll(
        RegExp(
          '($key\\s*[:=]\\s*)([^,}\\s]+)',
          caseSensitive: false,
        ),
        r'$1<redacted>',
      );
    }
    if (value.length > maxBodyLength) {
      value = '${value.substring(0, maxBodyLength - 1)}…';
    }
    return value;
  }

  bool _isSensitive(String key) => _sensitiveKeys.contains(key.toLowerCase());
}
