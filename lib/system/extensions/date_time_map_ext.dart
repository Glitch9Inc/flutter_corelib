extension DateTimeMapExt on Map<String, DateTime> {
  void setDateTime(String key, DateTime? value) {
    if (value != null) this[key] = value;
  }

  Map<String, String> toIso8601Map() {
    return map(
      (key, value) => MapEntry(key, value.toIso8601String()),
    );
  }
}

extension NullableDateTimeMapExt on Map<String, DateTime>? {
  DateTime? getDateTimeOrNull(String key) => this?[key];

  @Deprecated('Use getDateTimeOrNull and choose an explicit fallback.')
  DateTime getDateTimeOrNowIfNull(String key) {
    return getDateTimeOrNull(key) ?? DateTime.now();
  }
}
