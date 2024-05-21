import 'dart:async';
import 'dart:io';

import 'issue.dart';

class IssueExtensions {
  static Issue convert(Exception e) {
    if (e is IssueException) {
      return e.issue;
    } else if (e is HttpException) {
      return Issue.networkError;
    } else if (e is SocketException) {
      return _convertSocketException(e);
    } else if (e is TimeoutException) {
      return Issue.requestTimeout;
    } else if (e is IOException) {
      return Issue.fileNotFound;
    } else if (e is FormatException) {
      return Issue.invalidFormat;
    }
    // Add more specific cases as needed
    return Issue.unknownError;
  }

  static Issue _convertSocketException(SocketException e) {
    Issue code = _convertSocketExceptionStatus(e.osError?.errorCode);
    return code == Issue.unknownError ? _convertHttpException(e) : code;
  }

  static Issue _convertHttpException(SocketException e) {
    // Assuming you can retrieve HTTP status code from the exception, modify as necessary
    int? statusCode = e.osError?.errorCode;
    if (statusCode != null) {
      return _convertHttpStatusCode(statusCode);
    }
    return Issue.unknownError;
  }

  static Issue _convertHttpStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return Issue.invalidRequest;
      case 401:
        return Issue.permissionDenied;
      case 402:
        return Issue.serviceUnavailable;
      case 403:
        return Issue.forbidden;
      case 404:
        return Issue.invalidEndpoint;
      case 500:
        return Issue.internalServerError;
      default:
        return Issue.unknownError;
    }
  }

  static Issue _convertSocketExceptionStatus(int? status) {
    switch (status) {
      case -2:
        return Issue.serviceUnavailable;
      case -101:
        return Issue.protocolError;
      case -105:
        return Issue.noInternet;
      case -118:
        return Issue.requestTimeout;
      case -3:
        return Issue.sendFailed;
      case -4:
        return Issue.receiveFailed;
      case -26:
        return Issue.requestProhibitedByCachePolicy;
      case -27:
        return Issue.requestProhibitedByProxy;
      default:
        return Issue.unknownError;
    }
  }
}
