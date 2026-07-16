import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class DioLogInterceptor extends Interceptor {
  final Logger logger;
  final DioLogLevel logLevel;
  final Function(int)? errorStatusCodeHandler;

  DioLogInterceptor({
    DioLogLevel? logLevel,
    Logger? logger,
    this.errorStatusCodeHandler,
  })  : logLevel = logLevel ?? DioLogLevel(),
        logger = logger ?? Logger('Dio');

  bool isEmptyBody(dynamic data) {
    return data == null || data.toString().isEmpty || data.toString() == '{}';
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logLevel.requestUrl) {
      logger.info('Request [${options.method}] => PATH: ${options.path.yellow}');
    }

    if (logLevel.requestHeader) {
      for (var key in options.headers.keys) {
        logger.info('Request Header: $key = ${options.headers[key]}');
      }
    }

    if (logLevel.requestBody) {
      if (isEmptyBody(options.data)) {
        logger.info('Request Body is null or empty');
      } else {
        log('Request Body: ${options.data.toString()})}');
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (logLevel.responseUrl) {
      logger.info('Response [${response.statusCode}] => PATH: ${response.requestOptions.path.yellow}');
    }

    if (logLevel.responseBody) {
      if (isEmptyBody(response.data)) {
        logger.info('Response Body is null or empty');
      } else {
        log('Response Body: ${response.data.toString()}');
      }
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.severe('Error [${err.response?.statusCode}] => PATH: ${err.requestOptions.path.yellow}');
    logger.severe('Error Message: ${err.message}');
    if (errorStatusCodeHandler != null) {
      errorStatusCodeHandler!(err.response?.statusCode ?? 0);
    }
    super.onError(err, handler);
  }
}
