import 'package:flutter_corelib/flutter_corelib.dart';
import '../lib_database.dart';

abstract class CsvDatabase<T extends DataMixin> extends Database<CsvTable, T> {
  CsvDatabase({
    required super.dbName,
    List<DbTableItem<CsvTable, T>>? tableItems,
    String? csvPath,
    T Function(Map<String, dynamic>)? builder,
    int startColumn = 1,
    int startRow = 3,
    int idColumn = 1,
  })  : assert(tableItems != null || (csvPath != null && builder != null)),
        super(
            tableItems: tableItems ??
                [
                  DbTableItem.single(
                    name: csvPath!,
                    mapper: builder!,
                    startColumn: startColumn,
                    startRow: startRow,
                    idColumn: idColumn,
                  )
                ]);

  @override
  Future<void> loadDatabase() async {
    try {
      for (final item in tableItems) {
        item.table = CsvTable(item.name);

        if (item.mappingStrategy == MappingStrategy.single) {
          await _convertToMap(item);
        } else if (item.mappingStrategy == MappingStrategy.list) {
          await _convertToListMap(item);
        } else {
          await _convertToMap(item);
        }
      }
    } catch (e) {
      logSevere('Failed to load csv: $e');
    }
  }

  Future<void> _convertToMap(DbTableItem<CsvTable, T> item) async {
    final csv = item.table;
    final csvDataList = await csv!.toList(idColumn: item.idColumn, startRow: item.startRow);

    for (final data in csvDataList) {
      final model = item.mapper!(data);
      dataMap[model.id] = model;
    }
  }

  Future<void> _convertToListMap(DbTableItem<CsvTable, T> item) async {
    final csv = item.table;
    final csvDataMap = await csv!.toMap(idColumn: item.idColumn, startRow: item.startRow);

    for (final entry in csvDataMap.entries) {
      final id = entry.key;
      final data = entry.value;
      final model = item.listMapper!(data);
      dataMap[id] = model;
    }
  }
}
