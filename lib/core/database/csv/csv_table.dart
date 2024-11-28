import 'package:flutter/services.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

import '../lib_database.dart';

class CsvTable {
  static const kCsvDebugMode = false;
  late final Logger logger = Logger('Csv:$filePath');
  final String filePath;

  CsvTable(this.filePath);

  Future<List<Map<String, dynamic>>> toList({
    int idColumn = 0,
    int startRow = 2,
  }) async {
    final data = await rootBundle.loadString(filePath);
    final List<List<dynamic>> csvTable = const CsvToListConverter().convert(data);

    if (kCsvDebugMode) {
      logger.shout('Loaded CSV: $filePath');
    }

    if (csvTable.isEmpty) {
      logger.severe('Empty CSV: $filePath');
      return [];
    }

    final skipRow = (startRow - 1).clamp(0, csvTable.length - 1);
    final headers = csvTable.first.map((e) => DatabaseUtil.parseHeader(e.toString(), kCsvDebugMode)).toList();
    final csvData = csvTable.skip(skipRow).map((e) => Map<String, dynamic>.fromIterables(headers, e.map((e) => e.toString()))).toList();

    // isAvailable 필드가 FALSE인 데이터는 제외
    csvData.removeWhere((data) => data['isAvailable'] == 'FALSE');
    return csvData;
  }

  Future<Map<String, List<Map<String, dynamic>>>> toMap({
    int idColumn = 0,
    int startRow = 2,
  }) async {
    final data = await rootBundle.loadString(filePath);
    final List<List<dynamic>> csvTable = const CsvToListConverter().convert(data);

    if (kCsvDebugMode) {
      logger.shout('Loaded CSV: $filePath');
    }

    if (csvTable.isEmpty) {
      logger.severe('Empty CSV: $filePath');
      return {};
    }

    final skipRow = (startRow - 1).clamp(0, csvTable.length - 1);
    final headers = csvTable.first.map((e) => DatabaseUtil.parseHeader(e.toString(), kCsvDebugMode)).toList();
    final csvData = csvTable.skip(skipRow).map((e) => Map<String, dynamic>.fromIterables(headers, e.map((e) => e.toString()))).toList();

    // isAvailable 필드가 FALSE인 데이터는 제외
    csvData.removeWhere((data) => data['isAvailable'] == 'FALSE');

    final tempDataMap = <String, List<Map<String, dynamic>>>{};
    for (final data in csvData) {
      final id = data['uuid'];
      if (id == null) {
        logger.severe('Id not found in row');
        continue;
      }

      final stringId = id.toString();
      if (!tempDataMap.containsKey(stringId)) {
        tempDataMap[stringId] = [data];
      } else {
        tempDataMap[stringId]!.add(data);
      }
    }

    return tempDataMap;
  }
}
