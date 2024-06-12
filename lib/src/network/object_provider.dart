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

  Future<Result> create(List args) async {
    try {
      TObject obj = await createInternal(args);
      if (obj == null) return Result.fail("$objectName creation failed.");

      createController.add(obj);

      return ResultObject<TObject>.success(obj);
    } catch (e) {
      return Result.fail("$objectName creation failed. $e");
    }
  }

  Future<Result> retrieve(String id, List args) async {
    try {
      TObject? obj = await retrieveInternal(id, args);
      if (obj == null) return Result.fail("$objectName($id) not found.");

      retrieveController.add(obj);

      return ResultObject<TObject>.success(obj);
    } catch (e) {
      return Result.fail("$objectName retrieval failed. $e");
    }
  }

  Future<Result> retrieveOrCreate(String id, List args) async {
    Result result = await retrieve(id, args);
    if (result.isSuccess) return result;
    print("$objectName($id) retrieval failed. Creating new $objectName.");
    await Future.delayed(Duration(milliseconds: MIN_INTERNAL_OPERATION_MILLIS));

    return await create(args);
  }

  Future<bool> delete(String id, List args) async {
    try {
      bool deleted = await deleteInternal(id, args);
      if (!deleted) {
        deleteController.add(false);

        return false;
      }

      deleteController.add(true);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<TObject> createInternal(List args);
  Future<TObject?> retrieveInternal(String id, List args);
  Future<bool> deleteInternal(String id, List args);
}
