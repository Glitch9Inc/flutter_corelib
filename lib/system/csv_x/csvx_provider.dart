import 'package:flutter_corelib/flutter_corelib.dart';

abstract class CsvxProvider<T> extends CsvxController {
  final _data = <T>[].obs;
  List<T> get data => _data;
  bool isInit = false;
  bool _isInitializing = false;

  Future<void> _handleInit() async {
    if (isInit) return;
    if (_isInitializing) {
      logger.warning('Already initializing');
      return;
    }
    _isInitializing = true;
    await init();
    isInit = true;
    _isInitializing = false;
  }

  Future<List<T>> loadCsvItems() async {
    if (!isInit) await _handleInit();
    final csvData = await loadCsvTable();
    _data.value = csvData.map((data) => fromMap(data)).toList();
    return _data;
  }

  Future<void> init() async {}
  T fromMap(Map<String, Object?> map);
}
