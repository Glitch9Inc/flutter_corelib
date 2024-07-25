import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class LocalizationService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [sheets.SheetsApi.spreadsheetsReadonlyScope],
  );

  Future<Map<String, Map<String, String>>> fetchTranslations(
      String spreadsheetId, String range) async {
    final account = await _googleSignIn.signIn();
    final authHeaders = await account?.authHeaders;
    final client = IOClient();
    final authenticatedClient = AuthenticatedClient(client, authHeaders!);

    final sheetsApi = sheets.SheetsApi(authenticatedClient);
    final response =
        await sheetsApi.spreadsheets.values.get(spreadsheetId, range);

    final values = response.values ?? [];
    final translations = <String, Map<String, String>>{};

    for (var row in values) {
      final key = row[0] as String;
      translations[key] = {
        'en': row[1] as String,
        'es': row[2] as String,
        'fr': row[3] as String,
      };
    }

    return translations;
  }
}

class AuthenticatedClient extends http.BaseClient {
  final http.Client _inner;
  final Map<String, String> _headers;

  AuthenticatedClient(this._inner, this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request..headers.addAll(_headers));
  }
}
