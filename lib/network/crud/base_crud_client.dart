import 'package:flutter_corelib/flutter_corelib.dart';

abstract class BaseCrudClient<
    TModel extends CrudModelMixin, // the data model type
    TSelf extends BaseCrudClient<TModel, TSelf> // the client type itself
    > extends GetxService // extends GetxService so this client can be fetched with Get.find()
{
  // basic crud operations
  Future<Result<void>> create(TModel data);
  Future<Result<TModel?>> retrieve(String id);
  Future<Result<void>> update(TModel data);
  Future<Result<void>> delete(String id);

  // micro operations
  Future<Result<void>> setField(String id, String fieldName, dynamic value);
  Future<Result<void>> setMapValue(String id, String mapFieldName, String mapKey, dynamic value);

  // query operations
  Future<Result<TModel?>> query(String fieldName, dynamic value);
  Future<Result<List<TModel>>> list({String? orderBy, String id});

  // batch operations
  void batchSet(TModel data);
  void batchPatch(TModel data);
  void batchDelete(String id);
  Future<Result<void>> batchCommit();

  bool isBatchingTasks = false;

  TModel fromJson(Map<String, dynamic> json);
}
