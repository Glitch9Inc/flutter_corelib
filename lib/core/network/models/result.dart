import 'dart:core';

class Result<T> {
  final bool isSuccess;
  final String? message;
  final T? dto;

  Result({required this.isSuccess, this.message, this.dto});

  bool get isError => !isSuccess;
  bool get isFailure => !isSuccess;
  bool get hasData => dto != null;

  factory Result.successVoid() {
    return Result(isSuccess: true);
  }

  factory Result.isSuccess(T data) {
    return Result(isSuccess: true, dto: data);
  }

  factory Result.error(String message) {
    return Result(isSuccess: false, message: message);
  }
}
