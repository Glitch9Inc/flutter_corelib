import 'dart:core';

class Result<T> {
  final bool isSuccess;
  bool get isError => !isSuccess;
  bool get isFailure => !isSuccess;

  final T? data;
  final String? message;
  final Object? error;
  final StackTrace? stackTrace;

  bool get hasData => data != null;

  Result({
    required this.isSuccess,
    this.data,
    this.message,
    this.error,
    this.stackTrace,
  });

  factory Result.success({T? data, String? message}) {
    return Result(isSuccess: true, data: data, message: message);
  }

  factory Result.error(Object? error, {String? message, StackTrace? stackTrace}) {
    return Result(isSuccess: false, message: message, error: error, stackTrace: stackTrace);
  }
}
