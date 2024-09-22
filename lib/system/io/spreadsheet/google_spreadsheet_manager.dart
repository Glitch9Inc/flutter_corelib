import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:gsheets/gsheets.dart';

abstract class GoogleSpreadsheetManager {
  static final Logger logger = Logger('GoogleSpreadsheet');
  static GSheets? _defaultGSheets;
  static bool writeKeyIfNotExist = true;

  static void init(String credentials) {
    _defaultGSheets = GSheets(credentials);
  }

  static GSheets getGSheets(String? credentials) {
    if (credentials == null) return _defaultGSheets!;
    return GSheets(credentials);
  }
}
