// import 'dart:async';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// enum DatabaseType {
//   text,
//   real,
//   int,
//   dateTime,
//   blob,
//   bool,
// }

// extension DatabaseTypeExtension on DatabaseType {
//   String get dbType {
//     switch (this) {
//       case DatabaseType.text:
//         return 'TEXT NOT NULL';
//       case DatabaseType.real:
//         return 'REAL';
//       case DatabaseType.int:
//         return 'INTEGER NOT NULL';
//       case DatabaseType.dateTime:
//         return 'TEXT NOT NULL';
//       case DatabaseType.blob:
//         return 'BLOB';
//       case DatabaseType.bool:
//         return 'INTEGER NOT NULL';
//     }
//   }
// }

// enum DataRetentionPeriod {
//   permanent,
//   oneDay,
//   oneWeek,
//   oneMonth,
//   threeMonths,
//   sixMonths,
//   oneYear,
// }

// // 해당 Enum 값을 일수로 변환하는 확장 메서드
// extension DataRetentionPeriodExtension on DataRetentionPeriod {
//   int get days {
//     switch (this) {
//       case DataRetentionPeriod.oneDay:
//         return 1;
//       case DataRetentionPeriod.oneWeek:
//         return 7;
//       case DataRetentionPeriod.oneMonth:
//         return 30;
//       case DataRetentionPeriod.threeMonths:
//         return 90;
//       case DataRetentionPeriod.sixMonths:
//         return 180;
//       case DataRetentionPeriod.oneYear:
//         return 365;
//       case DataRetentionPeriod.permanent:
//         return -1; // 영구 보존
//     }
//   }
// }

// class EasyDatabase<TKey, TValue> {
//   static const textType = 'TEXT NOT NULL';
//   static const realType = 'REAL';
//   static const integerType = 'INTEGER NOT NULL';
//   static const blobType = 'BLOB';
//   static const dateTimeType = 'TEXT NOT NULL';

//   final String _dbName;
//   final Map<String, dynamic>? _sampleMap;
//   final Map<String, DatabaseType>? _schema;
//   final DatabaseType _keyType;
//   final DataRetentionPeriod _retentionPeriod;
//   final TValue Function(Map<String, dynamic>) _fromMap;
//   final Map<String, dynamic>? Function(TValue) _toMap;
//   Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('$_dbName.db');
//     return _database!;
//   }

//   EasyDatabase({
//     required String dbName,
//     required DatabaseType keyType,
//     required TValue Function(Map<String, dynamic>) fromMap,
//     required Map<String, dynamic>? Function(TValue) toMap,
//     Map<String, dynamic>? sampleMap,
//     Map<String, DatabaseType>? schema,
//     DataRetentionPeriod retentionPeriod = DataRetentionPeriod.permanent,
//   })  : _dbName = dbName,
//         _keyType = keyType,
//         _sampleMap = sampleMap,
//         _schema = schema,
//         _retentionPeriod = retentionPeriod,
//         _fromMap = fromMap,
//         _toMap = toMap {
//     if (_sampleMap == null && _schema == null) {
//       throw ArgumentError('Either sampleMap or schema must be provided.');
//     }
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     var db = await openDatabase(path, version: 1, onCreate: _createDB);

//     if (_retentionPeriod != DataRetentionPeriod.permanent) {
//       await _removeExpiredData(db);
//     }

//     return db;
//   }

//   Future<void> _removeExpiredData(Database db) async {
//     final now = DateTime.now();
//     final expiredDate = now.subtract(Duration(days: _retentionPeriod.days));

//     await db.delete(
//       _dbName,
//       where: 'created_at < ?',
//       whereArgs: [expiredDate.toIso8601String()],
//     );
//   }

//   Future _createDB(Database db, int version) async {
//     StringBuffer query = StringBuffer('CREATE TABLE $_dbName (');
//     query.write('key ${_keyType.dbType}, ');

//     if (_sampleMap != null) {
//       for (var kvp in _sampleMap.entries) {
//         query.write('${kvp.key} ${_getDBTypeFromDynamic(kvp.value)}, ');
//       }
//     } else if (_schema != null) {
//       for (var kvp in _schema.entries) {
//         query.write('${kvp.key} ${kvp.value.dbType}, ');
//       }
//     }

//     query.write('created_at TEXT NOT NULL, ');
//     query.write('PRIMARY KEY (key))');

//     await db.execute(query.toString());
//   }

//   String _getDBTypeFromDynamic(dynamic value) {
//     if (value is String) {
//       return textType;
//     } else if (value is int) {
//       return integerType;
//     } else if (value is double) {
//       return realType;
//     } else if (value is DateTime) {
//       return dateTimeType;
//     } else if (value is List<int>) {
//       return blobType;
//     } else if (value is bool) {
//       return integerType;
//     } else {
//       throw Exception('Unsupported type');
//     }
//   }

//   Future<void> insert(TKey key, TValue data) async {
//     final db = await database;

//     var map = _toMap(data);
//     if (map == null) {
//       throw Exception('Failed to convert data to map');
//     }

//     await db.insert(
//       _dbName,
//       {
//         'key': _convertKey(key),
//         'created_at': DateTime.now().toIso8601String(),
//         ...map,
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   dynamic _convertKey(TKey key) {
//     switch (_keyType) {
//       case DatabaseType.text:
//         return key as String;
//       case DatabaseType.int:
//         return key as int;
//       case DatabaseType.dateTime:
//         return (key as DateTime).toIso8601String();
//       case DatabaseType.blob:
//         return key as List<int>;
//       default:
//         throw Exception('Unsupported key type');
//     }
//   }

//   // get
//   Future<TValue?> get(TKey key) async {
//     final db = await database;

//     final result = await db.query(
//       _dbName,
//       where: 'key = ?',
//       whereArgs: [_convertKey(key)],
//     );

//     if (result.isEmpty) {
//       return null;
//     }

//     final json = result.first;
//     json.remove('created_at'); // created_at 필드를 제거
//     return _fromMap(json);
//   }

//   Future<void> delete(TKey key) async {
//     final db = await database;

//     await db.delete(
//       _dbName,
//       where: 'key = ?',
//       whereArgs: [_convertKey(key)],
//     );
//   }

//   Future<Map<TKey, TValue>> fetchAll() async {
//     final db = await database;

//     final result = await db.query(_dbName);
//     Map<TKey, TValue> map = {};

//     for (var json in result) {
//       final key = _convertKeyBack(json['key']);
//       json.remove('created_at'); // created_at 필드를 제거
//       final value = _fromMap(json);
//       map[key] = value;
//     }

//     return map;
//   }

//   TKey _convertKeyBack(dynamic key) {
//     switch (_keyType) {
//       case DatabaseType.text:
//         return key as TKey;
//       case DatabaseType.int:
//         return int.parse(key.toString()) as TKey;
//       case DatabaseType.dateTime:
//         return DateTime.parse(key as String) as TKey;
//       default:
//         throw Exception('Unsupported key type');
//     }
//   }

//   Future close() async {
//     final db = await database;
//     db.close();
//   }
// }
