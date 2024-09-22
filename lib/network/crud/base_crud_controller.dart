import 'package:flutter_corelib/flutter_corelib.dart';

abstract class BaseCrudController<TModel extends DtoBase<TModel>, TArg,
    TSelf extends BaseCrudController<TModel, TArg, TSelf>> {
  // basic crud operations
  Future<Result<void>> create(TModel data, {TArg arg});
  Future<Result<TModel?>> retrieve(String id, {TArg arg});
  Future<Result<void>> update(TModel data, {TArg arg});
  Future<Result<void>> delete(String id, {TArg arg});

  // micro operations
  Future<Result<void>> setField(String id, String fieldName, dynamic value, {TArg arg});
  Future<Result<void>> setMapValue(String id, String mapFieldName, String mapKey, dynamic value, {TArg arg});

  // query operations
  Future<Result<TModel?>> query(String fieldName, dynamic value, {TArg arg});
  Future<Result<List<TModel>>> list({String? orderBy, String id, TArg arg});

  // batch operations
  void batchSet(TModel data, {TArg arg});
  void batchPatch(TModel data, {TArg arg});
  void batchDelete(String id, {TArg arg});
  Future<Result<void>> batchCommit();

  bool isBatchingTasks = false;

  TModel fromJson(TSelf controller, Map<String, dynamic> json);
}
