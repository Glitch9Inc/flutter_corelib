import 'package:flutter_corelib/flutter_corelib.dart';

abstract class DataManager<TData extends DataMixin> {
  late final Logger logger = Logger(runtimeType.toString());
  final String dataName = TData.runtimeType.toString();

  // 유저 데이터
  final RxList<TData> list = <TData>[].obs;

  void add(TData dto) {
    list.add(dto);
  }

  TData? get(String uuid) {
    try {
      return list.firstWhere((element) => element.uuid == uuid);
    } catch (e) {
      logger.severe('$dataName not found with unique id: $uuid');
      return getFirst();
    }
  }

  TData? getFirst() {
    if (list.isEmpty) {
      logger.severe('$dataName list is empty');
      return null;
    }
    return list.first;
  }

  Future<void> remove(String uuid) async {
    try {
      list.removeWhere((element) => element.uuid == uuid);
    } catch (e) {
      logger.severe('$dataName not found with unique id: $uuid');
    }
  }

  Future<void> createOrUpdate(TData data) async {
    final create = list.every((element) => element.uuid != data.uuid);
    if (create) {
      list.add(data);
    } else {
      final index = list.indexWhere((element) => element.uuid == data.uuid);
      list[index] = data;
    }
  }
}
