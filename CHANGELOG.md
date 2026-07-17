## 0.3.0

- Split additional pure Dart utilities into `dart_corelib` with compatibility
  exports at the previous Flutter package paths.
- Add feature entrypoints for core, storage, network, IO network, audio,
  diagnostics, Flutter extensions, and platform IO.
- Remove external package re-exports and unused Firestore, Freezed, and
  Scratcher dependencies.
- Remove the embedded Discord webhook and require runtime reporter injection.
- Stop persisting authentication passwords and tokens in SharedPreferences.
- Make SharedPreferences initialization and writes awaitable and type-safe.
- Persist enum names while retaining legacy enum index/flag reads.
- Correct Unix UTC conversion, enum flags, ranges, overnight schedules, date
  helpers, value equality, timer cleanup, audio ownership, and Dio redaction.
- Add contract tests for storage, authentication, time/value objects,
  networking, timers, and audio.
- Keep the misspelled `dio_log_intercepter.dart` and old diagnostics path as
  deprecated compatibility shims for the 0.3.x migration window.

## 0.2.4

- Previous internal release.
