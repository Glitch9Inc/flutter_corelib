abstract class GoogleSpreadsheetConverter {
  static dynamic convert(String value) {
    final safeValue = value.toLowerCase().trim();

    if (safeValue == 'true') return true;
    if (safeValue == 'false') return false;
    if (safeValue == 'null') return null;
    if (safeValue == '[]') return [];
    if (safeValue == '{}') return {};

    // 숫자 타입인지 확인
    if (RegExp(r'^-?\d+(?:\.\d+)?$').hasMatch(safeValue)) {
      if (safeValue.contains('.')) {
        return double.parse(safeValue);
      } else {
        return int.parse(safeValue);
      }
    }

    return value;
  }
}
