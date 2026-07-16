import 'package:dio/dio.dart';

import 'dio_log_intercepter.dart';
import 'dio_log_level.dart';
import 'dio_settings.dart';

abstract class DioUtil {
  static Dio createDio(DioSettings clientSettings, [DioLogLevel? logSettings]) {
    var dio = Dio(BaseOptions(
      connectTimeout: clientSettings.connectTimeout,
      receiveTimeout: clientSettings.receiveTimeout,
      sendTimeout: clientSettings.sendTimeout,
      maxRedirects: clientSettings.maxRedirects,
    ));

    dio.interceptors.add(DioLogInterceptor(logLevel: logSettings));
    return dio;
  }
}
