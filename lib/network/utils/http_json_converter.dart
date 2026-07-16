import 'dart:convert';

abstract class HttpJsonConverter {
  static var encoder = const JsonEncoder.withIndent('  ');

  static String encode(Map<String, dynamic>? map) {
    try {
      return map == null ? '' : encoder.convert(map);
    } catch (e) {
      return '';
    }
  }

  static Map<String, dynamic>? decode(String? json) {
    try {
      return json == null ? null : jsonDecode(json);
    } catch (e) {
      return null;
    }
  }
}
