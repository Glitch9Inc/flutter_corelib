class DioLogLevel {
  final bool requestUrl;
  final bool requestHeader;
  final bool requestBody;
  final bool responseUrl;
  final bool responseBody;
  final bool redirection;

  DioLogLevel({
    this.requestUrl = true,
    this.requestHeader = false,
    this.requestBody = false,
    this.responseUrl = true,
    this.responseBody = true,
    this.redirection = true,
  });

  factory DioLogLevel.enableAll() {
    return DioLogLevel(
      requestUrl: true,
      requestHeader: true,
      requestBody: true,
      responseUrl: true,
      responseBody: true,
      redirection: true,
    );
  }
}
