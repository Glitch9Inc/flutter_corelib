import 'package:dio/dio.dart';

import 'dio_log_interceptor.dart';
import 'dio_log_level.dart';
import 'dio_settings.dart';

abstract class DioUtil {
  /// Creates a [Dio] wired to [DioLogInterceptor].
  ///
  /// Prefer this over a bare `Dio()` so every request goes through the same
  /// logging and redaction pipeline.
  static Dio createDio([DioSettings? clientSettings, DioLogLevel? logSettings]) {
    final settings = clientSettings ?? const DioSettings();
    var dio = Dio(BaseOptions(
      connectTimeout: settings.connectTimeout,
      receiveTimeout: settings.receiveTimeout,
      sendTimeout: settings.sendTimeout,
      maxRedirects: settings.maxRedirects,
    ));

    dio.interceptors.add(DioLogInterceptor(logLevel: logSettings));
    return dio;
  }
}
