import 'dart:core';

class Result<T> {
  final bool isSuccess;
  final String? message;
  final T? data;

  Result({required this.isSuccess, this.message, this.data});

  bool get isError => !isSuccess;
  bool get isFailure => !isSuccess;
  bool get hasData => data != null;

  factory Result.successVoid() {
    return Result(isSuccess: true);
  }

  factory Result.isSuccess(T data) {
    return Result(isSuccess: true, data: data);
  }

  factory Result.error(String message) {
    return Result(isSuccess: false, message: message);
  }
}
