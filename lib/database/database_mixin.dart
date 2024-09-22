import 'package:flutter_corelib/flutter_corelib.dart';

mixin DatabaseMixin<T extends DatabaseModelMixin> {
  bool isInit = false;
  bool _isInitializing = false;

  @protected
  Future<void> init() async {
    if (isInit) return;
    if (_isInitializing) return;
    _isInitializing = true;
    await loadDatabase();
    isInit = true;
    _isInitializing = false;
  }

  @protected
  Future<void> loadDatabase();

  @protected
  T fromMap(Map<String, Object?> map);

  T? get(String id);

  List<T?>? toList();

  List<T>? toNonNullList();
}
