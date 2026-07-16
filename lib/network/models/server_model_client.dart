mixin ServerModelClient<TDataModel, TBatchModel> {
  // basic crud operations
  Future<void> create(TDataModel data);
  Future<TDataModel?> retrieve(String id);
  Future<void> update(TDataModel data);
  Future<void> delete(String id);

  // micro operations
  Future<void> setField(String id, String fieldName, dynamic value);
  Future<void> setMapValue(String id, String mapFieldName, String mapKey, dynamic value);

  // query operations
  Future<TDataModel?> query(String fieldName, dynamic value);
  Future<List<TDataModel>> list({int? count, String? orderBy, String id});

  // batch operations
  Future<TBatchModel> batchSet(TDataModel data, {TBatchModel? batch});
  Future<TBatchModel> batchPatch(TDataModel data, {TBatchModel? batch});
  Future<TBatchModel> batchDelete(String id, {TBatchModel? batch});
}
