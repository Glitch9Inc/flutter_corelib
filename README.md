# flutter_corelib

Internal Flutter adapters and utilities shared by the Routina package family.
Pure Dart contracts live in the sibling `dart_corelib` package, while reusable
widgets and assets live in `flutter_corelib_ui`.

## Entry points

- `package:flutter_corelib/core.dart`: pure contracts and value objects
- `package:flutter_corelib/storage.dart`: SharedPreferences adapters and cache
- `package:flutter_corelib/audio.dart`: player contracts and local file adapter
- `package:flutter_corelib/diagnostics.dart`: bounded logging and optional reports
- `package:flutter_corelib/flutter_extensions.dart`: Flutter-oriented extensions
- `package:flutter_corelib/io.dart`: platform path adapter

`flutter_corelib.dart` remains as a compatibility umbrella during migration.
New code should use the narrow entrypoints above.

## Initialization

Initialize preferences once before constructing `Prefs`, `AudioChannel`, or
authentication session repositories:

```dart
import 'package:flutter_corelib/storage.dart';

Future<void> bootstrap() async {
  await FlutterPrefs.ensureInitialized();
}
```

Every mutation has an awaitable method. Prefer `Prefs.setValue` and
`PrefsCache.setValue` when write completion matters.

## Security and failure policy

- `AuthInfo` stores only non-secret profile/session metadata.
- Passwords and tokens must use an application-owned `CredentialStore`
  backed by platform secure storage.
- Diagnostics do not send data externally by default. Applications may inject
  their own `ErrorReporter` implementation.
- Strict JSON parsing is available through `JsonReader` from `dart_corelib`.

Dio configuration lives in the sibling `dart_dio` package. Authentication
session metadata is part of the `storage.dart` entrypoint.

The package is private (`publish_to: none`) and targets Dart 3.5+ and
Flutter 3.24+.
