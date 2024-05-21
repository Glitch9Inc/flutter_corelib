enum LogLevel {
  /// No logging.
  none,

  /// Logs basic information such as method entry and exit.
  basic,

  /// Logs detailed information such as request method and URL.
  detailed,

  /// Logs headers of requests and responses.
  headers,

  /// Logs headers and body of requests and responses.
  body,

  /// Logs headers, body, and stream of requests and responses.
  stream,

  /// Logs all details of requests and responses, including headers, body, and cookies.
  all,
}
