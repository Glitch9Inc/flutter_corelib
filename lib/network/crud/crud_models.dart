import 'package:flutter_corelib/flutter_corelib.dart';

/// Network data transfer object for crud operations
abstract class DtoBase<TModel> with DatabaseModelMixin {
  @override
  final String id;
  final BaseCrudController crud;

  DtoBase({required this.crud, required this.id});

  Map<String, Object?> toJson();

  Future<Result<void>> save() async => await crud.update(this);
  Future<Result<void>> create() async => await crud.create(this);
  Future<Result<void>> delete() async => await crud.delete(id);
  void setBatch() => crud.batchSet(this);
  void patchBatch() => crud.batchPatch(this);
}

/// General model DTO for crud operations
abstract class Dto<TModel> extends DtoBase<TModel> {
  late DateTime createdAt;
  late DateTime updatedAt;

  Dto({
    required super.crud,
    required super.id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }
}

/// History data DTO mainly used for recording daily history for crud operations
abstract class DailyDto<TModel> extends Dto<TModel> {
  Date date;

  DailyDto({
    required super.crud,
    required super.id,
    required this.date,
    super.createdAt,
    super.updatedAt,
  });
}
