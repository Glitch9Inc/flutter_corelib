import 'package:flutter_corelib/flutter_corelib.dart';

mixin DbTableMixin<T extends DbModelMixin> {
  bool isInit = false;
  Future<void>? _initFuture;

  Future<void> init() async {
    if (isInit) return;

    // 초기화가 진행 중이라면 동일한 Future를 반환
    _initFuture ??= _initializeDatabase();

    await _initFuture;
  }

  Future<void> _initializeDatabase() async {
    await loadDatabase();
    isInit = true;
  }

  @protected
  Future<void> loadDatabase();

  @protected
  T fromMap(Map<String, Object?> map);

  T? get(String id, [T? defaultValue]);

  List<T?>? toList();

  List<T>? toNonNullList();
}
