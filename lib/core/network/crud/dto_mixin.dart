import 'package:flutter_corelib/flutter_corelib.dart';

abstract class DtoMixin<TBatchModel extends BatchMixin> with DataMixin {
  /// The unique identifier of the model
  //String get uuid;

  @override
  String get id => uuid;

  @override
  String get uuid;

  /// The client that is used to handle the crud operations of this model
  CrudClient get client;

  /// Metadata of the model
  Map<String, dynamic> get data;

  /// Metadata 1. The date and time when the model was created
  DateTime get createdAt => data['createdAt'] as DateTime;
  set createdAt(DateTime value) => data['createdAt'] = value;

  /// Metadata 2. The date and time when the model was last updated
  DateTime get updatedAt => data['updatedAt'] as DateTime;
  set updatedAt(DateTime value) => data['updatedAt'] = value;

  /// Converts the model to a json object
  Map<String, Object?> toJson();

  // CRUD operations
  Future<Result<void>> crudCreate() async => await client.create(this);
  Future<Result<void>> crudUpdate() async => await client.update(this);
  Future<Result<void>> crudDelete() async => await client.delete(uuid);

  // Batch operations
  Future<TBatchModel> setBatch([TBatchModel? batch]) async => await client.batchSet(this, batch: batch) as TBatchModel;
  Future<TBatchModel> patchBatch([TBatchModel? batch]) async => await client.batchPatch(this, batch: batch) as TBatchModel;
  Future<TBatchModel> deleteBatch([TBatchModel? batch]) async => await client.batchDelete(uuid, batch: batch) as TBatchModel;
}
