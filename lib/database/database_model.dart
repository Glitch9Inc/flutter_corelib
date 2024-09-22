import 'package:flutter_corelib/database/database_model_mixin.dart';

abstract class DatabaseModel<T> with DatabaseModelMixin {
  @override
  final String id;

  DatabaseModel({required this.id});
}
