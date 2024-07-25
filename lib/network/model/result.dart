import 'dart:core';

class Result<T> {
  final bool success;
  final String? message;
  final T? data;

  Result({required this.success, this.message, this.data});

  bool get fail => !success;
  bool get hasData => data != null;

  factory Result.successVoid() {
    return Result(success: true);
  }

  factory Result.success(T data) {
    return Result(success: true, data: data);
  }

  factory Result.fail(String message) {
    return Result(success: false, message: message);
  }
}
