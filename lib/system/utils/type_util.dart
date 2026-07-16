class TypeUtil {
  static bool isBaseType(dynamic value) {
    return value is String || value is int || value is double || value is bool;
  }
}
