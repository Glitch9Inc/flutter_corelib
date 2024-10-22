import 'package:flutter_corelib/flutter_corelib.dart' hide File;
import 'package:flutter_corelib/database/spreadsheet/google_spreadsheet_converter.dart';
import 'package:gsheets/gsheets.dart';

class WorksheetItem<T extends DbModelMixin> {
  final String name;
  final int startColumn;
  final int startRow;
  final int idColumn;
  final T Function(Map<String, dynamic>) builder;

  WorksheetItem({
    required this.name,
    required this.builder,
    this.startColumn = 1,
    this.startRow = 3,
    this.idColumn = 1,
  });

  Worksheet? worksheet;
}

class SpreadsheetDatabase<T extends DbModelMixin> extends GetxController with DbTableMixin<T> {
  final String spreadsheetName;
  final String spreadsheetId;
  final String? credentials;
  final ValueRenderOption? valueRenderOption;
  final ValueInputOption? valueInputOption;
  final List<WorksheetItem<T>> worksheetItems;

  SpreadsheetDatabase({
    required this.spreadsheetId,
    this.spreadsheetName = 'Spreadsheet',
    this.credentials,
    this.valueRenderOption,
    this.valueInputOption,
    List<WorksheetItem<T>>? worksheetItems,
    String? worksheetName,
    T Function(Map<String, dynamic>)? builder,
    int startColumn = 1,
    int startRow = 3,
    int idColumn = 1,
  })  : assert(worksheetItems != null || (worksheetName != null && builder != null)),
        worksheetItems = worksheetItems ??
            [
              WorksheetItem(
                name: worksheetName!,
                builder: builder!,
                startColumn: startColumn,
                startRow: startRow,
                idColumn: idColumn,
              )
            ];

  final Map<String, T> dataMap = {};

  // State variables
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  bool get _isFailedToLoad => _failReason != null;
  String? _failReason;
  int _retryCount = 0;

  /* 
    주의사항
     - Row의 1번째 행은 헤더 행이어야 합니다.
     - Column과 Row의 Index는 0이 아니라 1부터 시작합니다.
     - Worksheet의 1번째 Column은 Id로 사용하는 String Column이어야 합니다.
  */

  @override
  Future<void> loadDatabase() async {
    if (worksheetItems.isNotNullOrEmpty) {
      _logSevere('Worksheet items is empty');
      return;
    }

    await _loadWorksheets();
  }

  Future<void> _loadWorksheets() async {
    try {
      final ss = await GoogleSpreadsheetManager.getSpreadsheet(spreadsheetId, credentials); // 특정 워크시트 접근 (이름으로)

      for (final item in worksheetItems) {
        var worksheet = ss.worksheetByTitle(item.name);
        if (worksheet != null) {
          item.worksheet = worksheet;
          _convertWorksheetsToDb(item);
        } else {
          _logSevere('Worksheet not found: ${item.name}');
        }
      }
    } catch (e) {
      if (_retryCount < GoogleSpreadsheetManager.maxRetry) {
        _retryCount++;
        _logWarning('Failed to load worksheet: $e. Retrying... $_retryCount');
        await Future.delayed(const Duration(seconds: 1));
        await _loadWorksheets();
      } else {
        _logSevere('Failed to load worksheet: $e');
      }
    }
  }

  Future<void> _convertWorksheetsToDb(WorksheetItem<T> worksheetItem) async {
    // 워크시트에서 데이터 로드 시작
    final name = worksheetItem.name;

    try {
      final worksheet = worksheetItem.worksheet;
      if (worksheet == null) {
        _logSevere('Worksheet $name not found');
        return;
      }

      final startColumn = worksheetItem.startColumn;
      final startRow = worksheetItem.startRow;
      final idColumn = worksheetItem.idColumn;
      final builder = worksheetItem.builder;

      // 1부터 모든 행 가져오기
      final allRows = await worksheet.values.allRows(fromRow: 1);
      if (allRows.isEmpty) {
        _logSevere(name, 'No data found in worksheet');
        return;
      }

      // 첫 번째 행은 헤더여야함
      final headers = allRows[0];

      // 데이터 행 반복
      for (int i = startRow - 1; i < allRows.length; i++) {
        final row = allRows[i];

        final Map<String, dynamic> rowData = {};

        // 헤더와 각 셀 값을 매핑
        for (int j = 0; j < headers.length && j < row.length; j++) {
          final key = headers[j];
          final value = row[j];
          rowData[key] = GoogleSpreadsheetConverter.convert(value);
        }

        // 첫 번째 컬럼의 Id 가져오기
        final id = rowData[headers[idColumn - 1]];
        if (id == null) {
          _logSevere(name, 'Id not found in row ${i + startRow}');
          continue;
        }

        _logInfo(name, 'Loading data: $id');

        final stringId = id.toString(); // id가 int일 경우를 대비하여 String으로 변환

        try {
          // builder 함수를 사용하여 객체 생성
          final T item = builder(rowData);

          // _data 맵에 추가
          dataMap[stringId] = item;
        } catch (e) {
          _logSevere(name, 'There was an error while creating object with provided builder: $e');
        }
      }

      _isLoaded = true;
    } catch (e) {
      _logSevere(name, 'Failed to load table: $e');
    }
  }

  // Future<void> writeCell(String value, int column, int row) async {
  //   if (!_validateState()) return;
  //   try {
  //     await worksheet!.values.insertValue(value, column: column, row: row);
  //   } catch (e) {
  //     _logSevere(e.toString());
  //   }
  // }

  void _logInfo(String message, [String? worksheetName]) {
    worksheetName ??= spreadsheetName;
    GoogleSpreadsheetManager.logger.info('$worksheetName: $message');
  }

  void _logWarning(String message, [String? worksheetName]) {
    worksheetName ??= spreadsheetName;
    GoogleSpreadsheetManager.logger.warning('$worksheetName: $message');
  }

  void _logSevere(String message, [String? worksheetName]) {
    worksheetName ??= spreadsheetName;
    GoogleSpreadsheetManager.logger.severe('$worksheetName: $message');
    _failReason = message;
  }

  bool _validateState() {
    if (_isFailedToLoad) {
      _logSevere(_failReason ?? 'Failed to load data');
      return false;
    }

    // if (!_isLoaded) {
    //   _logSevere('Data is not loaded yet');
    //   return false;
    // }

    return true;
  }

  // public methods & getters
  Map<String, T> get data {
    if (!_validateState()) return {};
    return dataMap;
  }

  T? operator [](String id) {
    if (!_validateState()) return null;
    return dataMap[id];
  }

  @override
  T? get(String id, [T? defaultValue]) {
    return dataMap[id] ?? defaultValue;
  }

  bool containsKey(String id) {
    if (!_validateState()) return false;
    return dataMap.containsKey(id);
  }

  void forEach(void Function(String id, T item) f) {
    if (!_validateState()) return;
    dataMap.forEach(f);
  }

  int get length {
    if (!_validateState()) return 0;
    return dataMap.length;
  }

  bool get isEmpty {
    if (!_validateState()) return true;
    return dataMap.isEmpty;
  }

  bool get isNotEmpty => !isEmpty;

  void clear() {
    dataMap.clear();
  }

  void remove(String id) {
    dataMap.remove(id);
  }

  @override
  T fromMap(Map<String, Object?> map) {
    throw UnimplementedError();
  }

  @override
  List<T?>? toList() {
    return dataMap.values.toList();
  }

  @override
  List<T>? toNonNullList() {
    return dataMap.values.toList().whereType<T>().toList();
  }
}
