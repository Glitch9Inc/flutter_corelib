import 'dart:async';

import '../result/result.dart';

abstract class ObjectProvider<TObject> {
  static const int MIN_INTERNAL_OPERATION_MILLIS = 100;

  final createController = StreamController<TObject>.broadcast();
  final retrieveController = StreamController<TObject>.broadcast();
  final deleteController = StreamController<bool>.broadcast();

  get onCreate => createController.stream;
  get onRetrieve => retrieveController.stream;
  get onDelete => deleteController.stream;

  final String objectName;
  ObjectProvider() : objectName = TObject.toString();

  Future<Result> create() async {
    try {
      TObject obj = await createInternal();
      if (obj == null) return Result.fail("$objectName creation failed.");

      createController.add(obj);

      return ResultObject<TObject>.success(obj);
    } catch (e) {
      return Result.fail("$objectName creation failed. $e");
    }
  }

  Future<Result> retrieve(String id) async {
    try {
      TObject? obj = await retrieveInternal(id);
      if (obj == null) return Result.fail("$objectName($id) not found.");

      retrieveController.add(obj);

      return ResultObject<TObject>.success(obj);
    } catch (e) {
      return Result.fail("$objectName retrieval failed. $e");
    }
  }

  Future<Result> retrieveOrCreate(String id) async {
    Result result = await retrieve(id);
    if (result.isSuccess) return result;
    print("$objectName($id) retrieval failed. Creating new $objectName.");
    await Future.delayed(const Duration(milliseconds: MIN_INTERNAL_OPERATION_MILLIS));

    return await create();
  }

  Future<Result> delete(String id) async {
    try {
      bool deleted = await deleteInternal(id);
      if (!deleted) {
        deleteController.add(false);

        return Result.fail("$objectName($id) deletion failed.");
      }

      deleteController.add(true);

      return Result.success("$objectName($id) deleted.");
    } catch (e) {
      return Result.fail("$objectName($id) deletion failed. $e");
    }
  }

  Future<TObject> createInternal();
  Future<TObject?> retrieveInternal(String id);
  Future<bool> deleteInternal(String id);
}
