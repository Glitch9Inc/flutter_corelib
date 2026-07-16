class DioSettings {
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final int maxRedirects;

  const DioSettings({
    this.connectTimeout = const Duration(seconds: 60),
    this.receiveTimeout = const Duration(seconds: 60),
    this.sendTimeout = const Duration(seconds: 60),
    this.maxRedirects = 15,
  });
}
