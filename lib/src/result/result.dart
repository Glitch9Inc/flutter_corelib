class Result {
  String? message;
  String? failReason;
  bool isSuccess = false;
  bool get isFailure => !isSuccess;

  Result();
  Result._internal(this.isSuccess, this.message, this.failReason);

  factory Result.success([String? outputMessage]) {
    return Result._internal(true, outputMessage, null);
  }

  factory Result.fail([String? failReason]) {
    return Result._internal(false, null, failReason);
  }
}

class ResultObject<T> extends Result {
  T? value;

  ResultObject();
  ResultObject._internal(super.isSuccess, super.message, super.failReason, this.value)
      : super._internal();

  factory ResultObject.success(T value, [String? outputMessage]) {
    return ResultObject._internal(true, outputMessage, null, value);
  }

  factory ResultObject.fail([String? failReason]) {
    return ResultObject._internal(false, null, failReason, null);
  }
}
