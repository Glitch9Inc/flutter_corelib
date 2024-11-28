import 'package:flutter_corelib/flutter_corelib.dart' hide File;
import 'package:flutter_corelib/core/database/spreadsheet/worksheet_converter.dart';
import 'package:gsheets/gsheets.dart';
import '../lib_database.dart';
import 'spreadsheet_config.dart';

class SpreadsheetDatabase<T extends DataMixin> extends Database<Worksheet, T> {
  final String spreadsheetId;
  final String? credentials;
  final ValueRenderOption? valueRenderOption;
  final ValueInputOption? valueInputOption;

  SpreadsheetDatabase({
    required super.dbName,
    required this.spreadsheetId,
    this.credentials,
    this.valueRenderOption,
    this.valueInputOption,
    List<DbTableItem<Worksheet, T>>? tableItems,
    String? worksheetName,
    T Function(Map<String, dynamic>)? builder,
    int startColumn = 1,
    int startRow = 3,
    int idColumn = 1,
  })  : assert(tableItems != null || (worksheetName != null && builder != null)),
        super(
            tableItems: tableItems ??
                [
                  DbTableItem.single(
                    name: worksheetName!,
                    mapper: builder!,
                    startColumn: startColumn,
                    startRow: startRow,
                    idColumn: idColumn,
                  )
                ]);

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
    if (tableItems.isNullOrEmpty) {
      logSevere('Worksheet items is empty');
      return;
    }

    await _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    Spreadsheet? ss;

    try {
      ss = await SpreadsheetManager.getSpreadsheet(spreadsheetId, credentials); // 특정 워크시트 접근 (이름으로)
    } catch (e) {
      if (_retryCount < SpreadsheetConfig.maxRetry) {
        _retryCount++;
        logWarning('$e. Retrying... $_retryCount');
        await Future.delayed(const Duration(seconds: 1));
        await _loadDatabase();
      } else {
        logSevere('Failed to load worksheet: $e');
      }
    }

    if (ss == null) {
      logSevere('Spreadsheet not found: $spreadsheetId');
      return;
    }

    for (final item in tableItems) {
      var worksheet = ss.worksheetByTitle(item.name);
      if (worksheet != null) {
        item.table = worksheet;
        //logInfo('Worksheet found: ${item.name}');

        if (item.mappingStrategy == MappingStrategy.single) {
          await _convertToMap(item);
        } else if (item.mappingStrategy == MappingStrategy.list) {
          await _convertToListMap(item);
        } else {
          await _convertToMap(item);
        }
      } else {
        logSevere('Worksheet not found: ${item.name}');
      }
    }
  }

  Future<void> _convertToMap(DbTableItem<Worksheet, T> tableItem) async {
    final name = tableItem.name;
    final worksheet = tableItem.table;
    final builder = tableItem.mapper;

    if (worksheet == null) {
      logSevere('Worksheet $name not found');
      return;
    }

    if (builder == null) {
      logSevere('$name mapper is null');
      return;
    }

    final tempDataList = await WorksheetConverter.toList(
      name,
      worksheet,
      tableItem.startRow,
      tableItem.idColumn,
    );

    if (tempDataList == null) {
      logSevere('Failed to convert worksheet to map');
      return;
    }

    // 컨버팅을 위한 try-catch문 시작
    try {
      //int count = 0;
      for (final data in tempDataList) {
        try {
          final T item = builder(data); // builder 함수를 사용하여 객체 생성
          dataMap[item.id] = item;
          //logInfo('Converted item: ${item.id}');
          //count++;
        } catch (e) {
          logSevere('There was an error while creating object with provided builder: $e, data: [$data]');
        }
      }
      //logInfo('Converted $count items from $name: ${dataMap.length}');
    } catch (e) {
      logSevere('Failed to convert data: $e');
    } finally {
      _isLoaded = true;
    }
  }

  Future<void> _convertToListMap(DbTableItem<Worksheet, T> tableItem) async {
    final name = tableItem.name;
    final worksheet = tableItem.table;
    final builder = tableItem.listMapper;

    if (worksheet == null) {
      logSevere('Worksheet $name not found');
      return;
    }

    if (builder == null) {
      logSevere('$name list mapper is null');
      return;
    }

    // 1개의 객체가 1줄(row)가 아닐 경우를 대비하여 Map으로 저장
    final tempDataMap = await WorksheetConverter.toMap(
      name,
      worksheet,
      tableItem.startRow,
      tableItem.idColumn,
    );

    if (tempDataMap == null) {
      logSevere('Failed to convert worksheet to map');
      return;
    }

    // 컨버팅을 위한 try-catch문 시작
    try {
      //int count = 0;
      for (final entry in tempDataMap.entries) {
        final stringId = entry.key;
        final rowData = entry.value;

        try {
          final T item = builder(rowData); // builder 함수를 사용하여 객체 생성
          dataMap[stringId] = item; // _data 맵에 추가
          //count++;
        } catch (e) {
          //logSevere('There was an error while creating object with provided builder: $e');
          // 더 자세한 로그를 출력하기 위해 아래와 같이 수정
          logSevere('There was an error while creating object with provided builder: $e, id: [$stringId], data: [$rowData]');
        }
      }
      //logInfo('Converted $count items from $name: ${dataMap.length}');
    } catch (e) {
      logSevere('Failed to convert data: $e');
    } finally {
      _isLoaded = true;
    }
  }

  Future<void> writeCell(Worksheet worksheet, String value, int column, int row) async {
    if (!_validateState()) return;
    try {
      await worksheet.values.insertValue(value, column: column, row: row);
    } catch (e) {
      logSevere(e.toString());
    }
  }

  bool _validateState() {
    if (_isFailedToLoad) {
      logSevere(_failReason ?? 'Failed to load data');
      return false;
    }
    return true;
  }
}
