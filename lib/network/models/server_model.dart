import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:uuid/uuid.dart';

abstract class ServerModel {
  /// The unique identifier of the model
  final String id;

  /// The client that is used to handle the crud operations of this model
  ServerModelClient get client;

  /// Timestamps of the model
  final Map<String, DateTime> timestamps;

  /// The date and time when the model was created
  DateTime get createdAt => timestamps['created_at'] ?? DateTime.now();
  set createdAt(DateTime value) => timestamps['created_at'] = value;

  /// The date and time when the model was last updated
  DateTime get updatedAt => timestamps['updated_at'] ?? DateTime.now();
  set updatedAt(DateTime value) => timestamps['updated_at'] = value;

  ServerModel({
    String? id,
    Map<String, DateTime>? timestamps,
  })  : id = id ?? const Uuid().v4(),
        timestamps = timestamps ?? {'created_at': DateTime.now()};

  ServerModel.fromJson(Map<String, dynamic> json)
      : id = json.getString('id'),
        timestamps = json.getDateTimeMap('timestamps');

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'id': id};
    if (timestamps.isNotEmpty) json['timestamps'] = timestamps;
    return json;
  }

  // CRUD operations
  Future<void> crudCreate() async => await client.create(this);
  Future<void> crudUpdate() async => await client.update(this);
  Future<void> crudDelete() async => await client.delete(id);

  // Batch operations
  Future<Object> setBatch([Object? batch]) async => await client.batchSet(this, batch: batch);
  Future<Object> patchBatch([Object? batch]) async => await client.batchPatch(this, batch: batch);
  Future<Object> deleteBatch([Object? batch]) async => await client.batchDelete(id, batch: batch);
}
