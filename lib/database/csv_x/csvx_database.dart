import 'package:flutter_corelib/flutter_corelib.dart';

abstract class CsvxDatabase<T extends DbModelMixin> extends CsvxController with DbTableMixin<T> {
  final CacheMap<String, T> cache = CacheMap<String, T>();

  CsvxDatabase() {
    init();
  }

  @override
  Future<void> loadDatabase() async {
    final csvData = await loadCsvTable();
    var dataList = csvData.map((data) => fromMap(data)).toList();

    for (var data in dataList) {
      cache.set(data.id, data);
    }
  }

  @override
  T fromMap(Map<String, dynamic> map);

  @override
  T get(String id, [T? defaultValue]) {
    if (!isInit) {
      logger.warning('Database is not initialized');
      return defaultValue ?? fromMap({});
    }

    if (cache.containsKey(id)) {
      return cache.get(id) ?? defaultValue ?? fromMap({});
    } else {
      logger.warning('Data not found: $id');
      return defaultValue ?? fromMap({});
    }
  }

  @override
  List<T?>? toList() {
    if (!isInit) {
      logger.warning('Database is not initialized');
      return null;
    }

    return cache.toList();
  }

  @override
  List<T>? toNonNullList() {
    if (!isInit) {
      logger.warning('Database is not initialized');
      return null;
    }

    return cache.toList()?.whereType<T>().toList();
  }

  List<String> getKeys() {
    return cache.cachedData.keys.toList();
  }
}
