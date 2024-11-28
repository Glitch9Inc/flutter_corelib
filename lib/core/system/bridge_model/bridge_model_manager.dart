import 'package:flutter_corelib/flutter_corelib.dart';

class BridgeModelManager<TBridgeModel extends BridgeModel<TDtoModel, TDbDataModel>, TDtoModel extends DtoMixin,
    TDbDataModel extends DataMixin> extends DataManager<TBridgeModel> {
  @override
  Future<void> remove(String uuid) async {
    try {
      final schedule = list.firstWhereOrNull((element) => element.uuid == uuid);
      if (schedule == null) {
        logger.severe('$dataName not found with unique id: $uuid');
        return;
      }
      await schedule.dto.crudDelete();
      list.removeWhere((element) => element.uuid == uuid);
    } catch (e) {
      logger.severe('$dataName not found with unique id: $uuid');
    }
  }

  @override
  Future<void> createOrUpdate(TBridgeModel data) async {
    final create = list.every((element) => element.uuid != data.uuid);
    if (create) {
      Debug.info('Creating new $dataName: ${data.uuid}');
      await data.dto.crudCreate();
      Debug.shout('$dataName created: ${data.uuid}');
      list.add(data);
    } else {
      Debug.info('Updating $dataName: ${data.uuid}');
      await data.dto.crudUpdate();
      Debug.shout('$dataName updated: ${data.uuid}');
    }
  }
}
