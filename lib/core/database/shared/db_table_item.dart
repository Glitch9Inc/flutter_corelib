import 'package:flutter_corelib/core/database/lib_database.dart';

class DbTableItem<TTable, TModel extends DataMixin> {
  final String name;
  final MappingStrategy mappingStrategy;
  final int startColumn;
  final int startRow;
  final int idColumn;
  final TModel Function(Map<String, dynamic>)? mapper;
  final TModel Function(List<Map<String, dynamic>>)? listMapper;

  DbTableItem.single({
    required this.name,
    required this.mapper,
    this.startColumn = 1,
    this.startRow = 3,
    this.idColumn = 1,
  })  : mappingStrategy = MappingStrategy.single,
        listMapper = null;

  DbTableItem.list({
    required this.name,
    required this.listMapper,
    this.startColumn = 1,
    this.startRow = 3,
    this.idColumn = 1,
  })  : mappingStrategy = MappingStrategy.list,
        mapper = null;

  TTable? table;
}
