import 'package:flutter_corelib/flutter_corelib.dart';

mixin CrudModelMixin {
  /// The unique identifier of the model
  String get id;

  /// The client that is used to handle the crud operations of this model
  BaseCrudClient get client;

  /// Metadata of the model
  Map<String, dynamic> get metadata;

  /// Metadata 1. The date and time when the model was created
  DateTime get createdAt => metadata['createdAt'] as DateTime;
  set createdAt(DateTime value) => metadata['createdAt'] = value;

  /// Metadata 2. The date and time when the model was last updated
  DateTime get updatedAt => metadata['updatedAt'] as DateTime;
  set updatedAt(DateTime value) => metadata['updatedAt'] = value;

  /// Optional Metadata 1. The date set to the model (used for daily history data)
  DateTime get date => metadata['date'] as DateTime;
  set date(DateTime value) => metadata['date'] = value;

  /// Converts the model to a json object
  Map<String, Object?> toJson();
}

/// General model DTO for crud operations
abstract class CrudModel with CrudModelMixin {
  @override
  final String id;

  @override
  final Map<String, dynamic> metadata = {};

  CrudModel({
    required this.id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dateTime,
    Date? date,
  })  : assert(id.isNotEmpty),
        assert(dateTime != null && date != null) // dateTime and date cannot be set at the same time
  {
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
    if (dateTime != null) this.date = dateTime;
    if (date != null) this.date = date.toDateTime();
  }

  @override
  Map<String, Object?> toJson();

  Future<Result<void>> crudCreate() async => await client.create(this);
  Future<Result<void>> crudUpdate() async => await client.update(this);
  Future<Result<void>> crudDelete() async => await client.delete(id);

  void setBatch() => client.batchSet(this);
  void patchBatch() => client.batchPatch(this);
}
