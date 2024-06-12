const String noMessage = "No message provided";
const String unknownError = "Unknown error";

class Result {
  String message;
  String failReason;
  bool isSuccess = false;
  bool get isFailure => !isSuccess;

  Result._internal(this.isSuccess, this.message, this.failReason);

  factory Result.success([String outputMessage = noMessage]) {
    return Result._internal(true, outputMessage, unknownError);
  }

  factory Result.fail([String failReason = unknownError]) {
    return Result._internal(false, noMessage, failReason);
  }
}

class ResultObject<T> extends Result {
  T? value;

  ResultObject._internal(super.isSuccess, super.message, super.failReason, this.value)
      : super._internal();

  factory ResultObject.success(T value, [String outputMessage = noMessage]) {
    return ResultObject._internal(true, outputMessage, unknownError, value);
  }

  factory ResultObject.fail([T? value, String failReason = unknownError]) {
    return ResultObject._internal(false, noMessage, failReason, value);
  }
}
