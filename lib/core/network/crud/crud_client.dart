import 'package:flutter_corelib/flutter_corelib.dart';

abstract class CrudClient<TDtoModel extends DtoMixin, TBatchModel extends BatchMixin,
    TSelf extends CrudClient<TDtoModel, TBatchModel, TSelf>> {
  // basic crud operations
  Future<Result<void>> create(TDtoModel data);
  Future<Result<TDtoModel?>> retrieve(String id);
  Future<Result<void>> update(TDtoModel data);
  Future<Result<void>> delete(String id);

  // micro operations
  Future<Result<void>> setField(String id, String fieldName, dynamic value);
  Future<Result<void>> setMapValue(String id, String mapFieldName, String mapKey, dynamic value);

  // query operations
  Future<Result<TDtoModel?>> query(String fieldName, dynamic value);
  Future<Result<List<TDtoModel>>> list({String? orderBy, String id});

  // batch operations
  Future<TBatchModel> batchSet(TDtoModel data, {TBatchModel? batch});
  Future<TBatchModel> batchPatch(TDtoModel data, {TBatchModel? batch});
  Future<TBatchModel> batchDelete(String id, {TBatchModel? batch});

  TDtoModel fromJson(Map<String, dynamic> json);
}
