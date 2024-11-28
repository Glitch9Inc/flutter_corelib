import 'package:flutter_corelib/flutter_corelib.dart';

/// A model that bridges between a DTO and a database data.
abstract class BridgeModel<TDto extends DtoMixin, TDbData extends DataMixin> with DataMixin {
  /// The client used to perform CRUD operations.
  CrudClient get client;

  /// The database table used to fetch data.
  Database get database;

  @override
  String get id => dbData.id;

  @override
  String get uuid => dto.uuid;

  // To be implemented by the subclass
  String? get name;
  String? get description;

  late final TDto dto;
  late TDbData dbData;
  final TDto Function()? dtoFactory;
  final TDbData Function()? dbDataFactory;

  /// Creates the model from an ID, DTO, or data.
  /// If the DTO or data is not provided, it will be fetched from the client or database.
  /// DO NOT use this model immediately after creation if the DTO or data is not provided.
  /// It uses async operations to fetch necessary data.
  BridgeModel({
    String? dtoId,
    String? dbDataId,
    TDto? dto,
    TDbData? dbData,
    this.dtoFactory,
    this.dbDataFactory,
  })  : assert((dbDataId != null && dbDataId.isNotEmpty) || dbData != null, 'DbData ID or DB data must be provided'),
        assert((dtoId != null && dtoId.isNotEmpty) || dto != null, 'DTO ID or DTO must be provided') {
    if (dto != null) {
      this.dto = dto;
    } else {
      _fetchDto(dtoId!);
    }

    if (dbData != null) {
      this.dbData = dbData;
    } else {
      _fetchData(dbDataId!);
    }
  }

  /// Fetches the DTO using the client and handles errors.
  Future<void> _fetchDto(String dtoId) async {
    try {
      var result = await client.retrieve(dtoId);

      if (result.isFailure) {
        final errorMessage = 'Failed to retrieve model($dtoId) from dto: ${result.message}';
        if (dtoFactory != null) {
          Debug.severe('$errorMessage Trying to create dto from factory...');
          dto = dtoFactory!();
        } else {
          throw Exception(errorMessage);
        }
      } else {
        if (result.dto == null) throw Exception('Failed to retrieve model($dtoId) from dto: data is null');
        if (result.dto is! TDto) throw Exception('Failed to retrieve model($dtoId) from dto: data is not of type $TDto');
        dto = result.dto! as TDto;
      }
    } catch (e) {
      Debug.severe(e);
    }
  }

  /// Fetches the data from the database and handles initialization errors.
  Future<void> _fetchData(String dbDataId) async {
    try {
      if (!database.isInit) {
        Debug.warning('Database(${database.dbName}) is not initialized. Trying to initialize...');
        await database.init();
      }

      var nullableData = database.get(dbDataId);

      if (nullableData == null) {
        final errorMessage = 'Data($dbDataId) is null.';

        if (dbDataFactory != null) {
          Debug.severe('$errorMessage Trying to create data from factory...');
          nullableData = dbDataFactory!();
        } else {
          throw Exception(errorMessage);
        }
      }

      if (nullableData is! TDbData) throw Exception('Data($dbDataId) is not of type $TDbData');

      dbData = nullableData;
    } catch (e) {
      Debug.severe('Failed to create model from dto: data is null. Error: $e');
    }
  }
}
