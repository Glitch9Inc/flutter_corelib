import 'dart:async';
import 'package:flutter_corelib/flutter_corelib.dart';

abstract class ObjectProvider<TObject> {
  // ignore: constant_identifier_names
  static const int MIN_INTERNAL_OPERATION_MILLIS = 100;

  final createController = StreamController<TObject>.broadcast();
  final retrieveController = StreamController<TObject>.broadcast();
  final deleteController = StreamController<bool>.broadcast();

  Stream<TObject> get onCreate => createController.stream;
  Stream<TObject> get onRetrieve => retrieveController.stream;
  Stream<bool> get onDelete => deleteController.stream;

  final String objectName;
  final Logger logger = Logger('ObjectProvider<$TObject>');

  ObjectProvider() : objectName = TObject.toString();

  Future<TObject?> create() async {
    logger.info("Creating '$objectName'...");
    try {
      Result result = await createInternal();
      if (result.isError) {
        logger.severe(result.message);
        return null;
      }

      if (result is! Result<TObject>) {
        logger.severe("Invalid result type. Expected ResultObject<$TObject> but got $result.");
        return null;
      }

      TObject? obj = result.dto;
      if (obj == null) {
        logger.severe("'$objectName' creation failed. $result");
        return null;
      }

      createController.add(obj);
      return obj;
    } catch (e, stackTrace) {
      logger.severe("'$objectName' creation failed. $e");
      logger.severe(stackTrace.toString());
      return null;
    }
  }

  Future<TObject?> retrieve(String id, {bool surpressWarning = false}) async {
    logger.info("Retrieving '$objectName($id)'...");
    try {
      Result result = await retrieveInternal(id);
      if (result.isError) {
        logger.severe(result.message);
        return null;
      }

      if (result is! Result<TObject>) {
        if (!surpressWarning) logger.severe("Invalid result type. Expected ResultObject<$TObject> but got $result.");
        return null;
      }

      TObject? obj = result.dto;

      if (obj == null) {
        if (!surpressWarning) logger.severe("'$objectName($id)' retrieval failed. $result");
        return null;
      }

      retrieveController.add(obj);

      return obj;
    } catch (e, stackTrace) {
      if (!surpressWarning) {
        logger.severe("'$objectName($id)' retrieval failed. $e");
        logger.severe(stackTrace.toString());
      }

      return null;
    }
  }

  Future<TObject?> retrieveOrCreate(String id) async {
    TObject? obj = await retrieve(id, surpressWarning: true);
    if (obj != null) {
      return obj;
    }

    return create();
  }

  Future<bool> delete(String id) async {
    logger.info("Deleting '$objectName($id)'...");
    try {
      Result result = await deleteInternal(id);
      if (result.isError) {
        logger.severe(result.message);
        return false;
      }

      deleteController.add(true);
      return true;
    } catch (e, stackTrace) {
      logger.severe("'$objectName($id)' deletion failed. $e");
      logger.severe(stackTrace.toString());
      return false;
    }
  }

  Future<List<TObject>> list(int count) async {
    logger.info("Listing '$objectName'...");
    try {
      Result result = await listInternal(count);
      if (result.isError) {
        logger.severe(result.message);
        return [];
      }

      if (result is! Result<List<TObject>>) {
        logger.severe("Invalid result type. Expected ResultObject<List<$TObject>> but got $result.");
        return [];
      }

      List<TObject>? objects = result.dto;
      if (objects == null) {
        logger.severe("'$objectName' listing failed. $result");
        return [];
      }

      return objects;
    } catch (e, stackTrace) {
      logger.severe("'$objectName' listing failed. $e");
      logger.severe(stackTrace.toString());
      return [];
    }
  }

  Future<Result> createInternal();
  Future<Result> retrieveInternal(String id);
  Future<Result> deleteInternal(String id);
  Future<Result> listInternal(int count);
}
