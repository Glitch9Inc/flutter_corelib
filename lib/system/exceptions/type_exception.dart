class TypeException implements Exception {
  final String message;

  TypeException(Type expectedType, Type actualType) : message = 'Expected type $expectedType, but got $actualType';

  @override
  String toString() {
    return 'TypeException: $message';
  }
}
