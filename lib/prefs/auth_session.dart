import 'dart:async';

import 'flutter_prefs.dart';

enum AuthType {
  none,
  emailAndPassword,
  googleSignIn,
  appleSignIn,
}

abstract class AuthConfig {
  static const kPrefsKeyName = 'auth_name';
  static const kPrefsKeyEmail = 'auth_email';
  static const kPrefsKeyAuthType = 'auth_auth_type';

  static const _legacyPasswordKey = 'auth_password';
  static const _legacyTokenKey = 'auth_token';
}

/// Immutable authentication profile containing no secrets.
class AuthInfo {
  final AuthType type;
  final String name;
  final String email;

  const AuthInfo({
    required this.type,
    required this.name,
    required this.email,
  });

  static Future<void> saveToPrefs({
    required AuthType type,
    required String name,
    required String email,
  }) {
    return const AuthSessionRepository().save(
      AuthInfo(type: type, name: name, email: email),
    );
  }

  static AuthInfo loadFromPrefs() => const AuthSessionRepository().load();

  static Future<void> removeFromPrefs() =>
      const AuthSessionRepository().clear();
}

/// Persists only non-secret authentication session metadata.
class AuthSessionRepository {
  const AuthSessionRepository();

  AuthInfo load() {
    final storedType =
        FlutterPrefs.getPrefs().get(AuthConfig.kPrefsKeyAuthType);
    final storedName = storedType is String ? storedType : null;
    final legacyIndex = storedType is int ? storedType : null;

    final type = _parseType(storedName, legacyIndex);
    unawaited(_removeLegacyCredentials());

    return AuthInfo(
      type: type,
      name: FlutterPrefs.getString(AuthConfig.kPrefsKeyName),
      email: FlutterPrefs.getString(AuthConfig.kPrefsKeyEmail),
    );
  }

  Future<void> save(AuthInfo info) async {
    await Future.wait(<Future<void>>[
      FlutterPrefs.setString(AuthConfig.kPrefsKeyAuthType, info.type.name),
      FlutterPrefs.setString(AuthConfig.kPrefsKeyName, info.name),
      FlutterPrefs.setString(AuthConfig.kPrefsKeyEmail, info.email),
      _removeLegacyCredentials(),
    ]);
  }

  Future<void> clear() async {
    await Future.wait(<Future<void>>[
      FlutterPrefs.remove(AuthConfig.kPrefsKeyName),
      FlutterPrefs.remove(AuthConfig.kPrefsKeyEmail),
      FlutterPrefs.remove(AuthConfig.kPrefsKeyAuthType),
      _removeLegacyCredentials(),
    ]);
  }

  AuthType _parseType(String? name, int? legacyIndex) {
    if (name != null) {
      for (final value in AuthType.values) {
        if (value.name == name) return value;
      }
    }
    if (legacyIndex != null &&
        legacyIndex >= 0 &&
        legacyIndex < AuthType.values.length) {
      return AuthType.values[legacyIndex];
    }
    return AuthType.none;
  }

  Future<void> _removeLegacyCredentials() async {
    await Future.wait(<Future<void>>[
      FlutterPrefs.remove(AuthConfig._legacyPasswordKey),
      FlutterPrefs.remove(AuthConfig._legacyTokenKey),
    ]);
  }
}

/// Application-owned secret persistence boundary.
abstract interface class CredentialStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> clear();
}
