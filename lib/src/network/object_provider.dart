import 'dart:async';

import 'package:flutter_corelib/flutter_corelib.dart';

abstract class ObjectProvider<TObject> {
  // ignore: constant_identifier_names
  static const int MIN_INTERNAL_OPERATION_MILLIS = 100;

  final createController = StreamController<TObject>.broadcast();
  final retrieveController = StreamController<TObject>.broadcast();
  final deleteController = StreamController<bool>.broadcast();

  get onCreate => createController.stream;
  get onRetrieve => retrieveController.stream;
  get onDelete => deleteController.stream;

  final String objectName;
  final Logger logger;

  ObjectProvider()
      : objectName = TObject.toString(),
        logger = Logger("ObjectProvider<$TObject>");

  Future<TObject?> create() async {
    try {
      Result result = await createInternal();
      if (result.isFailure) {
        logger.error(result.failReason);
        return null;
      }

      if (result is! ResultObject<TObject>) {
        logger.error("Invalid result type. Expected ResultObject<$TObject> but got $result.");
        return null;
      }

      TObject? obj = result.value;
      if (obj == null) {
        logger.error("$objectName creation failed. $result");
        return null;
      }

      createController.add(obj);
      return obj;
    } catch (e) {
      logger.error("$objectName creation failed. $e");
      return null;
    }
  }

  Future<TObject?> retrieve(String id) async {
    try {
      Result result = await retrieveInternal(id);
      if (result.isFailure) {
        logger.error(result.failReason);
        return null;
      }

      if (result is! ResultObject<TObject>) {
        logger.error("Invalid result type. Expected ResultObject<$TObject> but got $result.");
        return null;
      }

      TObject? obj = result.value;

      if (obj == null) {
        logger.error("$objectName($id) retrieval failed. $result");
        return null;
      }

      retrieveController.add(obj);

      return obj;
    } catch (e) {
      logger.error("$objectName($id) retrieval failed. $e");
      return null;
    }
  }

  Future<TObject?> retrieveOrCreate(String id) async {
    TObject? obj = await retrieve(id);
    if (obj != null) {
      return obj;
    }

    return create();
  }

  Future<bool> delete(String id) async {
    try {
      Result result = await deleteInternal(id);
      if (result.isFailure) {
        logger.error(result.failReason);
        return false;
      }

      deleteController.add(true);
      return true;
    } catch (e) {
      logger.error("$objectName($id) deletion failed. $e");
      return false;
    }
  }

  Future<Result> createInternal();
  Future<Result> retrieveInternal(String id);
  Future<Result> deleteInternal(String id);
}
