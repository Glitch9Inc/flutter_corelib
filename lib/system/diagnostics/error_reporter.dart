/// Optional destination for application error reports.
///
/// Implementations belong to the application integration layer so the core
/// diagnostics package does not depend on an HTTP client or vendor API.
abstract interface class ErrorReporter {
  Future<void> report(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  });
}
