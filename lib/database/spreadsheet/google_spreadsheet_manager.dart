import 'dart:io';

import 'package:flutter_corelib/flutter_corelib.dart' hide File;
import 'package:gsheets/gsheets.dart';

abstract class GoogleSpreadsheetManager {
  static final Logger logger = Logger('GoogleSpreadsheet');

  static final Map<String, GSheets> _gSheetsMap = {};
  static final Map<String, Spreadsheet> _spreadsheetMap = {};

  static GSheets? _defaultGSheets;
  static bool writeKeyIfNotExist = true;
  static String csvFilePath = 'assets/csv';
  static int maxRetry = 3;

  static void init({
    required String credentials,
    String? csvFilePath,
    int? maxRetry,
  }) {
    _defaultGSheets = GSheets(credentials);
    if (csvFilePath != null) GoogleSpreadsheetManager.csvFilePath = csvFilePath;
    if (maxRetry != null) GoogleSpreadsheetManager.maxRetry = maxRetry;
  }

  static GSheets getGSheets(String? credentials) {
    if (credentials == null) {
      if (_defaultGSheets == null) {
        throw Exception('Default GSheets is not initialized');
      }
      return _defaultGSheets!;
    }

    if (_gSheetsMap.containsKey(credentials)) {
      return _gSheetsMap[credentials]!;
    }

    final gSheets = GSheets(credentials);
    _gSheetsMap[credentials] = gSheets;
    return gSheets;
  }

  static Future<Spreadsheet> getSpreadsheet(String spreadsheetId, String? credentials) async {
    if (_spreadsheetMap.containsKey(spreadsheetId)) {
      return _spreadsheetMap[spreadsheetId]!;
    }

    final gSheets = getGSheets(credentials);
    final spreadsheet = await gSheets.spreadsheet(spreadsheetId);
    _spreadsheetMap[spreadsheetId] = spreadsheet;
    return spreadsheet;
  }

  static Future<void> saveToCsv(WorksheetItem worksheetItem) async {
    // 워크시트에서 데이터 로드 시작
    if (worksheetItem.worksheet == null) {
      logger.severe('Worksheet not found for ${worksheetItem.name}');
      return;
    }

    final filePath = '${GoogleSpreadsheetManager.csvFilePath}/${worksheetItem.name}.csv';
    final List<List<dynamic>> csvData = [];

    try {
      // 1부터 모든 행 가져오기
      final allRows = await worksheetItem.worksheet!.values.allRows(fromRow: 1);
      if (allRows.isEmpty) {
        logger.severe('No data found in worksheet');
        return;
      }

      csvData.addAll(allRows);
    } catch (e) {
      logger.severe(e.toString());
    }

    // Convert data to CSV format
    final String csv = const ListToCsvConverter().convert(csvData);

    // Write to file
    final file = File(filePath);
    await file.writeAsString(csv);

    logger.info('Saved to $filePath');
  }
}
