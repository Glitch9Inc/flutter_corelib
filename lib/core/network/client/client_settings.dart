class ClientSettings {
  Duration connectTimeout = const Duration(seconds: 60);
  Duration receiveTimeout = const Duration(seconds: 60);
  Duration sendTimeout = const Duration(seconds: 60);
  int maxRedirects = 5;
}
