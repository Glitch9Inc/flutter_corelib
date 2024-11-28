import 'package:flutter_corelib/flutter_corelib.dart';
import '../lib_database.dart';

abstract class Database<TTable, TModel extends DataMixin> {
  final String dbName;
  final Map<String, TModel> dataMap = {};
  final List<DbTableItem<TTable, TModel>> tableItems;

  Database({
    required this.dbName,
    required this.tableItems,
  });

  bool isInit = false;
  Future<void>? _initFuture;

  Future<void> init() async {
    if (isInit) {
      Debug.severe('Database $dbName is already initialized');
      return;
    }

    // 초기화가 진행 중이라면 동일한 Future를 반환
    _initFuture ??= _initDatabase();
    await _initFuture;
  }

  Future<void> _initDatabase() async {
    await loadDatabase();
    isInit = true;
  }

  /// Override this
  @protected
  Future<void> loadDatabase();

  TModel? operator [](String id) {
    return dataMap[id];
  }

  TModel? get(String id, [TModel? defaultValue]) {
    return dataMap[id] ?? defaultValue;
  }

  bool containsKey(String id) {
    return dataMap.containsKey(id);
  }

  List<String> getKeys() {
    return dataMap.keys.toList();
  }

  void forEach(void Function(String id, TModel item) f) {
    dataMap.forEach(f);
  }

  int get length {
    return dataMap.length;
  }

  bool get isEmpty {
    return dataMap.isEmpty;
  }

  bool get isNotEmpty => !isEmpty;

  void clear() {
    dataMap.clear();
  }

  void remove(String id) {
    dataMap.remove(id);
  }

  List<TModel> toList() {
    return dataMap.values.toList();
  }

  void logInfo(String message) {
    DatabaseUtil.logInfo(dbName, message);
  }

  void logWarning(String message) {
    DatabaseUtil.logWarning(dbName, message);
  }

  void logSevere(String message) {
    DatabaseUtil.logSevere(dbName, message);
  }
}
