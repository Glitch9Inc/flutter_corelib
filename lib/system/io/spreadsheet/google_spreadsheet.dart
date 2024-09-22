import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:flutter_corelib/system/io/spreadsheet/google_spreadsheet_converter.dart';
import 'package:gsheets/gsheets.dart';

class GoogleSpreadsheet<T extends DatabaseModelMixin> extends GetxController with DatabaseMixin<T> {
  final String spreadsheetId;
  final String worksheetName;
  final String? credentials;
  final ValueRenderOption? valueRenderOption;
  final ValueInputOption? valueInputOption;
  final bool loadImmediately;
  final int startColumn;
  final int startRow;
  final int idColumn;
  final T Function(Map<String, dynamic>) builder;

  GoogleSpreadsheet({
    required this.spreadsheetId,
    required this.worksheetName,
    required this.builder,
    this.credentials,
    this.valueRenderOption,
    this.valueInputOption,
    this.loadImmediately = true,
    this.startColumn = 1,
    this.startRow = 3, // 1번째 행은 헤더, 2번째 행은 설명
    this.idColumn = 1,
  }) {
    if (loadImmediately) {
      init();
    }
  }

  static Future<GoogleSpreadsheet> create<T extends DatabaseModelMixin>({
    required String spreadsheetId,
    required String worksheetName,
    required T Function(Map<String, dynamic>) builder,
    String? credentials,
    ValueRenderOption? valueRenderOption,
    ValueInputOption? valueInputOption,
    bool loadImmediately = true,
    int startColumn = 1,
    int startRow = 3,
    int idColumn = 1,
  }) async {
    final instance = GoogleSpreadsheet(
      spreadsheetId: spreadsheetId,
      worksheetName: worksheetName,
      builder: builder,
      credentials: credentials,
      valueRenderOption: valueRenderOption,
      valueInputOption: valueInputOption,
      loadImmediately: loadImmediately,
      startColumn: startColumn,
      startRow: startRow,
      idColumn: idColumn,
    );

    if (loadImmediately) {
      await instance.init();
    }

    return instance;
  }

  // final GSheets? _gsheets;
  Worksheet? _worksheet;
  final Map<String, T> _data = {};

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  bool get _isFailedToLoad => _failReason != null;
  String? _failReason;

  /* 
    주의사항
     - Row의 1번째 행은 헤더 행이어야 합니다.
     - Column과 Row의 Index는 0이 아니라 1부터 시작합니다.
     - Worksheet의 1번째 Column은 Id로 사용하는 String Column이어야 합니다.
  */

  @override
  Future<void> loadDatabase() async {
    await _loadWorksheet();

    if (_worksheet == null) {
      _logSevere('Worksheet not found');
    }

    await _loadTable();
  }

  Future<void> _loadWorksheet() async {
    try {
      final gsheets = GoogleSpreadsheetManager.getGSheets(credentials);
      // 특정 워크시트 접근 (이름으로)
      final ss = await gsheets.spreadsheet(spreadsheetId);
      _worksheet = ss.worksheetByTitle(worksheetName);
    } catch (e) {
      _logSevere(e.toString());
    }
  }

  Future<void> _loadTable() async {
    // 워크시트에서 데이터 로드 시작
    try {
      // 1부터 모든 행 가져오기
      final allRows = await _worksheet!.values.allRows(fromRow: 1);
      if (allRows.isEmpty) {
        _logSevere('No data found in worksheet');
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
          _logSevere('Id not found in row ${i + startRow}');
          continue;
        }

        _logInfo('Loading data: $id');

        // builder 함수를 사용하여 객체 생성
        final T item = builder(rowData);

        // _data 맵에 추가
        _data[id] = item;
      }

      _isLoaded = true;
    } catch (e) {
      _logSevere(e.toString());
    }
  }

  Future<void> writeCell(String value, int column, int row) async {
    if (!_validateState()) return;
    try {
      await _worksheet!.values.insertValue(value, column: column, row: row);
    } catch (e) {
      _logSevere(e.toString());
    }
  }

  void _logInfo(String message) {
    GoogleSpreadsheetManager.logger.info('$worksheetName: $message');
  }

  void _logSevere(String message) {
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
    return _data;
  }

  T? operator [](String id) {
    if (!_validateState()) return null;
    return _data[id];
  }

  @override
  T? get(String id) {
    return this[id];
  }

  bool containsKey(String id) {
    if (!_validateState()) return false;
    return _data.containsKey(id);
  }

  void forEach(void Function(String id, T item) f) {
    if (!_validateState()) return;
    _data.forEach(f);
  }

  int get length {
    if (!_validateState()) return 0;
    return _data.length;
  }

  bool get isEmpty {
    if (!_validateState()) return true;
    return _data.isEmpty;
  }

  bool get isNotEmpty => !isEmpty;

  void clear() {
    _data.clear();
  }

  void remove(String id) {
    _data.remove(id);
  }

  @override
  T fromMap(Map<String, Object?> map) {
    return builder(map);
  }

  @override
  List<T?>? toList() {
    return _data.values.toList();
  }

  @override
  List<T>? toNonNullList() {
    return _data.values.toList().whereType<T>().toList();
  }
}
