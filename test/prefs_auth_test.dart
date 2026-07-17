import 'package:flutter_corelib/network/auth/auth_info.dart';
import 'package:flutter_corelib/prefs/flutter_prefs.dart';
import 'package:flutter_corelib/prefs/prefs.dart';
import 'package:flutter_corelib/prefs/prefs_list.dart';
import 'package:flutter_corelib/prefs/prefs_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _Choice { first, second, third }

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    FlutterPrefs.setPreferencesForTesting(
      await SharedPreferences.getInstance(),
    );
    Prefs.clearCache();
    PrefsList.clearCache();
    PrefsMap.clearCache();
  });

  tearDown(FlutterPrefs.resetForTesting);

  test('supported generic values round trip', () async {
    final now = DateTime(2026, 7, 17, 12, 34, 56);
    await FlutterPrefs.set<String>('string', 'value');
    await FlutterPrefs.set<int>('int', 7);
    await FlutterPrefs.set<double>('double', 1.5);
    await FlutterPrefs.set<bool>('bool', true);
    await FlutterPrefs.set<DateTime>('date', now);
    await FlutterPrefs.set<List<String>>('strings', <String>['a', 'b']);
    await FlutterPrefs.set<List<int>>('ints', <int>[1, 2]);
    await FlutterPrefs.set<List<double>>('doubles', <double>[1.25, 2.5]);
    await FlutterPrefs.set<List<bool>>('bools', <bool>[true, false]);
    await FlutterPrefs.set<Map<String, dynamic>>(
      'json',
      <String, dynamic>{'answer': 42},
    );

    expect(FlutterPrefs.get<String>('string'), 'value');
    expect(FlutterPrefs.get<int>('int'), 7);
    expect(FlutterPrefs.get<double>('double'), 1.5);
    expect(FlutterPrefs.get<bool>('bool'), isTrue);
    expect(FlutterPrefs.get<DateTime>('date'), now);
    expect(FlutterPrefs.get<List<String>>('strings'), <String>['a', 'b']);
    expect(FlutterPrefs.get<List<int>>('ints'), <int>[1, 2]);
    expect(FlutterPrefs.get<List<double>>('doubles'), <double>[1.25, 2.5]);
    expect(FlutterPrefs.get<List<bool>>('bools'), <bool>[true, false]);
    expect(
      FlutterPrefs.get<Map<String, dynamic>>('json'),
      <String, dynamic>{'answer': 42},
    );
  });

  test('enum names round trip and legacy index remains readable', () async {
    await FlutterPrefs.setEnum('choice', _Choice.second);
    await FlutterPrefs.setEnumList(
      'choices',
      <_Choice>[_Choice.first, _Choice.third],
    );

    expect(
      FlutterPrefs.getEnum('choice', _Choice.values),
      _Choice.second,
    );
    expect(
      FlutterPrefs.getEnumList('choices', _Choice.values),
      <_Choice>[_Choice.first, _Choice.third],
    );

    await FlutterPrefs.setInt('legacy', 2);
    expect(
      FlutterPrefs.getEnum('legacy', _Choice.values),
      _Choice.third,
    );
  });

  test('same preference key cannot be reused with a different type', () {
    Prefs.create<int>('typed-key', 0);
    expect(
      () => Prefs.create<String>('typed-key', ''),
      throwsStateError,
    );
  });

  test('auth session stores metadata and removes legacy credentials', () async {
    await FlutterPrefs.setString('auth_password', 'legacy-password');
    await FlutterPrefs.setString('auth_token', 'legacy-token');

    await const AuthSessionRepository().save(
      const AuthInfo(
        type: AuthType.googleSignIn,
        name: 'Routina',
        email: 'user@example.com',
      ),
    );

    final restored = const AuthSessionRepository().load();
    expect(restored.type, AuthType.googleSignIn);
    expect(restored.name, 'Routina');
    expect(restored.email, 'user@example.com');
    expect(FlutterPrefs.hasKey('auth_password'), isFalse);
    expect(FlutterPrefs.hasKey('auth_token'), isFalse);
    expect(
      FlutterPrefs.getString(AuthConfig.kPrefsKeyAuthType),
      AuthType.googleSignIn.name,
    );
  });

  test('corrupt auth type falls back to none', () async {
    await FlutterPrefs.setString(AuthConfig.kPrefsKeyAuthType, 'removed-value');
    expect(const AuthSessionRepository().load().type, AuthType.none);
  });
}
