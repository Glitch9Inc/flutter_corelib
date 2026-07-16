import 'package:flutter_corelib/prefs/flutter_prefs.dart';

enum AuthType {
  none,
  emailAndPassword,
  googleSignIn,
  appleSignIn,
  // add more auth types here...
}

abstract class AuthConfig {
  static const kPrefsKeyName = 'auth_name';
  static const kPrefsKeyEmail = 'auth_email';
  static const kPrefsKeyPassword = 'auth_password';
  static const kPrefsKeyToken = 'auth_token';
  static const kPrefsKeyAuthType = 'auth_auth_type';
}

class AuthInfo {
  final AuthType type;
  final String name;
  final String email;
  final String password;
  final String token;

  AuthInfo({
    required this.type,
    required this.name,
    required this.email,
    required this.password,
    required this.token,
  }) {
    saveToPrefs(
      type: type,
      name: name,
      email: email,
      password: password,
      token: token,
    );
  }

  static void saveToPrefs({
    required AuthType type,
    required String name,
    required String email,
    String? password,
    String? token,
  }) {
    FlutterPrefs.setInt(AuthConfig.kPrefsKeyAuthType, type.index);
    FlutterPrefs.setString(AuthConfig.kPrefsKeyName, name);
    FlutterPrefs.setString(AuthConfig.kPrefsKeyEmail, email);

    if (password != null) {
      FlutterPrefs.setString(AuthConfig.kPrefsKeyPassword, password);
    }

    if (token != null) {
      FlutterPrefs.setString(AuthConfig.kPrefsKeyToken, token);
    }
  }

  static AuthInfo loadFromPrefs() {
    return AuthInfo(
      type: AuthType.values[FlutterPrefs.getInt(AuthConfig.kPrefsKeyAuthType)],
      name: FlutterPrefs.getString(AuthConfig.kPrefsKeyName),
      email: FlutterPrefs.getString(AuthConfig.kPrefsKeyEmail),
      password: FlutterPrefs.getString(AuthConfig.kPrefsKeyPassword),
      token: FlutterPrefs.getString(AuthConfig.kPrefsKeyToken),
    );
  }

  static void removeFromPrefs() {
    FlutterPrefs.remove(AuthConfig.kPrefsKeyName);
    FlutterPrefs.remove(AuthConfig.kPrefsKeyEmail);
    FlutterPrefs.remove(AuthConfig.kPrefsKeyPassword);
    FlutterPrefs.remove(AuthConfig.kPrefsKeyToken);
    FlutterPrefs.remove(AuthConfig.kPrefsKeyAuthType);
  }
}
