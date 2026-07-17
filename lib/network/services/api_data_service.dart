import 'dart:async';

import 'package:dart_corelib/models/result.dart';
import 'package:logging/logging.dart';

enum APIDataFailureKind {
  notFound,
  unauthorized,
  validation,
  network,
  parsing,
  unknown,
}

class APIDataException implements Exception {
  final APIDataFailureKind kind;
  final String message;
  final Object? cause;

  const APIDataException(this.kind, this.message, {this.cause});

  @override
  String toString() => 'APIDataException($kind, $message)';
}

sealed class APIDataEvent<T> {
  const APIDataEvent();
}

final class APIDataCreated<T> extends APIDataEvent<T> {
  final T value;
  const APIDataCreated(this.value);
}

final class APIDataRetrieved<T> extends APIDataEvent<T> {
  final T value;
  const APIDataRetrieved(this.value);
}

final class APIDataDeleted<T> extends APIDataEvent<T> {
  final String id;
  const APIDataDeleted(this.id);
}

abstract class APIDataService<TObject> {
  final _eventController = StreamController<APIDataEvent<TObject>>.broadcast();
  final _createController = StreamController<TObject>.broadcast();
  final _retrieveController = StreamController<TObject>.broadcast();
  final _deleteController = StreamController<bool>.broadcast();
  final _deletedIdController = StreamController<String>.broadcast();

  Stream<APIDataEvent<TObject>> get events => _eventController.stream;
  Stream<TObject> get onCreate => _createController.stream;
  Stream<TObject> get onRetrieve => _retrieveController.stream;
  Stream<bool> get onDelete => _deleteController.stream;
  Stream<String> get onDeletedId => _deletedIdController.stream;

  final String objectName;
  final Logger logger;
  bool _isDisposed = false;

  APIDataService({Logger? logger})
      : objectName = TObject.toString(),
        logger = logger ?? Logger('APIDataService<$TObject>');

  Future<Result<TObject>> createResult({String? id}) async {
    return _guard(() async {
      final result = await createInternal(id: id);
      final value = result.data;
      if (result.isSuccess && value != null) {
        _emit(APIDataCreated<TObject>(value));
        _createController.add(value);
      }
      return result;
    }, operation: 'create');
  }

  Future<Result<TObject>> retrieveResult(String id) async {
    return _guard(() async {
      final result = await retrieveInternal(id);
      final value = result.data;
      if (result.isSuccess && value != null) {
        _emit(APIDataRetrieved<TObject>(value));
        _retrieveController.add(value);
      }
      return result;
    }, operation: 'retrieve');
  }

  Future<Result<void>> deleteResult(String id) async {
    return _guard(() async {
      final result = await deleteInternal(id);
      if (result.isSuccess) {
        _emit(APIDataDeleted<TObject>(id));
        _deleteController.add(true);
        _deletedIdController.add(id);
      }
      return result;
    }, operation: 'delete');
  }

  Future<Result<List<TObject>>> listResult(int count) {
    if (count < 0) {
      return Future<Result<List<TObject>>>.value(
        Result<List<TObject>>.error(
          const APIDataException(
            APIDataFailureKind.validation,
            'count must not be negative',
          ),
        ),
      );
    }
    return _guard(() => listInternal(count), operation: 'list');
  }

  /// Compatibility API. Prefer [createResult] when failure details matter.
  Future<TObject?> create({String? id}) async {
    final result = await createResult(id: id);
    _logFailure(result);
    return result.data;
  }

  /// Compatibility API. Prefer [retrieveResult].
  Future<TObject?> retrieve(
    String id, {
    bool suppressWarning = false,
    @Deprecated('Use suppressWarning.') bool? surpressWarning,
  }) async {
    final result = await retrieveResult(id);
    if (!(surpressWarning ?? suppressWarning)) _logFailure(result);
    return result.data;
  }

  Future<TObject?> retrieveOrCreate(String id) async {
    final retrieved = await retrieveResult(id);
    if (retrieved.isSuccess) return retrieved.data;

    final error = retrieved.error;
    if (error is! APIDataException ||
        error.kind != APIDataFailureKind.notFound) {
      _logFailure(retrieved);
      return null;
    }
    return create(id: id);
  }

  /// Compatibility API. Prefer [deleteResult].
  Future<bool> delete(String id) async {
    final result = await deleteResult(id);
    _logFailure(result);
    return result.isSuccess;
  }

  /// Compatibility API. Prefer [listResult].
  Future<List<TObject>> list(int count) async {
    final result = await listResult(count);
    _logFailure(result);
    return result.data ?? <TObject>[];
  }

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    await Future.wait(<Future<void>>[
      _eventController.close(),
      _createController.close(),
      _retrieveController.close(),
      _deleteController.close(),
      _deletedIdController.close(),
    ]);
  }

  Future<Result<TObject>> createInternal({String? id});
  Future<Result<TObject>> retrieveInternal(String id);
  Future<Result<void>> deleteInternal(String id);
  Future<Result<List<TObject>>> listInternal(int count);

  Future<Result<T>> _guard<T>(
    Future<Result<T>> Function() action, {
    required String operation,
  }) async {
    if (_isDisposed) {
      return Result<T>.error(
        StateError('$runtimeType is disposed'),
        message: '$operation rejected after dispose',
      );
    }
    try {
      return await action();
    } on Object catch (error, stackTrace) {
      return Result<T>.error(
        error,
        message: '$objectName $operation failed',
        stackTrace: stackTrace,
      );
    }
  }

  void _emit(APIDataEvent<TObject> event) {
    if (!_isDisposed) _eventController.add(event);
  }

  void _logFailure(Result<dynamic> result) {
    if (result.isSuccess) return;
    logger.warning(
      result.message ?? '$objectName operation failed',
      result.error,
      result.stackTrace,
    );
  }
}
