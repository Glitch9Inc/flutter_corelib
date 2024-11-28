import 'package:gsheets/gsheets.dart';
import '../lib_database.dart';

abstract class WorksheetConverter {
  static dynamic convertValue(String value) {
    final safeValue = value.toLowerCase().trim();

    if (safeValue == 'true') return true;
    if (safeValue == 'false') return false;
    if (safeValue == 'null') return null;
    if (safeValue == '[]') return [];
    if (safeValue == '{}') return {};

    // 숫자 타입인지 확인
    if (RegExp(r'^-?\d+(?:\.\d+)?$').hasMatch(safeValue)) {
      if (safeValue.contains('.')) {
        return double.parse(safeValue);
      } else {
        return int.parse(safeValue);
      }
    }

    return value;
  }

  static Future<List<Map<String, dynamic>>?> toList(
    String name,
    Worksheet worksheet,
    int startRow,
    int idColumn,
  ) async {
    // 1부터 모든 행 가져오기
    final allRows = await worksheet.values.allRows(fromRow: 1);
    if (allRows.isEmpty) {
      DatabaseUtil.logSevere(name, 'No data found in worksheet');
      return null;
    }

    // 첫 번째 행은 헤더여야함
    final headers = allRows[0];
    final tempDataList = <Map<String, dynamic>>[];

    // 데이터 추출을 위한 try-catch문 시작
    try {
      // 데이터 행 반복
      for (int i = startRow - 1; i < allRows.length; i++) {
        final row = allRows[i];
        final Map<String, dynamic> rowData = {};

        // 헤더와 각 셀 값을 매핑
        for (int j = 0; j < headers.length && j < row.length; j++) {
          final key = headers[j];

          if (key.startsWith('*')) continue;

          final value = row[j];
          rowData[key] = WorksheetConverter.convertValue(value);
        }

        tempDataList.add(rowData);
      }
    } catch (e) {
      DatabaseUtil.logSevere(name, 'Failed to load table: $e');
    }

    return tempDataList;
  }

  static Future<Map<String, List<Map<String, dynamic>>>?> toMap(
    String name,
    Worksheet worksheet,
    int startRow,
    int idColumn,
  ) async {
    // 1부터 모든 행 가져오기
    final allRows = await worksheet.values.allRows(fromRow: 1);
    if (allRows.isEmpty) {
      DatabaseUtil.logSevere(name, 'No data found in worksheet');
      return null;
    }

    // 첫 번째 행은 헤더여야함
    final headers = allRows[0];
    final tempDataMap = <String, List<Map<String, dynamic>>>{};

    // 데이터 추출을 위한 try-catch문 시작
    try {
      // 데이터 행 반복
      for (int i = startRow - 1; i < allRows.length; i++) {
        final row = allRows[i];
        final Map<String, dynamic> rowData = {};

        // 헤더와 각 셀 값을 매핑
        for (int j = 0; j < headers.length && j < row.length; j++) {
          final key = headers[j];

          // key가 *로 시작하면 해당 열은 무시
          if (key.startsWith('*')) continue;

          final value = row[j];
          rowData[key] = WorksheetConverter.convertValue(value);
        }

        // 첫 번째 컬럼의 Id 가져오기
        final id = rowData[headers[idColumn - 1]];
        if (id == null) {
          DatabaseUtil.logSevere(name, 'Id not found in row ${i + startRow}');
          continue;
        }

        DatabaseUtil.logInfo(name, 'Loading data: $id');

        final stringId = id.toString(); // id가 int일 경우를 대비하여 String으로 변환

        if (!tempDataMap.containsKey(stringId)) {
          tempDataMap[stringId] = [rowData];
        } else {
          tempDataMap[stringId]!.add(rowData);
        }
      }
    } catch (e) {
      DatabaseUtil.logSevere(name, 'Failed to load table: $e');
    }

    return tempDataMap;
  }
}
