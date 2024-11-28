import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_corelib/flutter_corelib.dart';

class DioLoggingInterceptor extends Interceptor {
  final Logger _logger = Logger('Dio');
  late LogSettings _logSettings;

  DioLoggingInterceptor({LogSettings? logSettings}) {
    _logSettings = logSettings ?? LogSettings();
  }

  String _formatJsonToReadableLog(String json) {
    try {
      // Decode the JSON string into a Map
      final Map<String, dynamic> decodedJson = jsonDecode(json);

      // Encode the JSON map into a pretty-printed format
      final String prettyJson = const JsonEncoder.withIndent('  ').convert(decodedJson);

      return prettyJson;
    } catch (e) {
      // If parsing fails, return the original string
      return json;
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_logSettings.enabled) _logger.info('Request [${options.method}] => PATH: ${options.path.yellow}');
    if (_logSettings.showRequestHeaders) _logger.info('Headers: ${options.headers}');
    if (_logSettings.showRequestBody) {
      bool nullOrEmpty = options.data == null || options.data.toString().isEmpty || options.data.toString() == '{}';
      if (nullOrEmpty && !_logSettings.hideEmptyBody) _logger.info('Request Body is null or empty');
      if (!nullOrEmpty) _logger.info('Request Body: ${_formatJsonToReadableLog(options.data)}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_logSettings.enabled) {
      _logger.info('Response [${response.statusCode}] => PATH: ${response.requestOptions.path.yellow}');
    }
    if (_logSettings.showResponseBody) {
      bool nullOrEmpty = response.data == null || response.data.toString().isEmpty || response.data.toString() == '{}';
      if (nullOrEmpty && !_logSettings.hideEmptyBody) _logger.info('Response Body is null or empty');
      if (!nullOrEmpty) _logger.info('Response Body: ${_formatJsonToReadableLog(response.data)}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.severe('Error [${err.response?.statusCode}] => PATH: ${err.requestOptions.path.yellow}');
    _logger.severe('Error Message: ${err.message}');
    super.onError(err, handler);
  }
}
