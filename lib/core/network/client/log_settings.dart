class LogSettings {
  bool enabled;
  bool showRequestHeaders;
  bool showRequestBody;
  bool showResponseBody;
  bool hideEmptyBody;
  bool showRedirections;

  LogSettings({
    this.enabled = true,
    this.showRequestHeaders = false,
    this.showRequestBody = false,
    this.showResponseBody = false,
    this.hideEmptyBody = true,
    this.showRedirections = false,
  });
}
