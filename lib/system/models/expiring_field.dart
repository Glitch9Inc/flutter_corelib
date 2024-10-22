class ExpiringField<T> {
  final String id;
  final T? value;
  final DateTime? expiresAt;
  final bool Function()? condition;

  ExpiringField({
    required this.id,
    this.value,
    this.expiresAt,
    this.condition,
  });

  // Time-based expiration
  ExpiringField.duration({
    required this.id,
    this.value,
    required Duration duration,
  })  : expiresAt = DateTime.now().add(duration),
        condition = null;

  // Condition-based expiration
  ExpiringField.condition({
    required this.id,
    this.value,
    required this.condition,
  }) : expiresAt = null;

  bool get _isTimeExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  bool get _isConditionExpired => condition != null && condition!();

  // Expiration check
  bool isExpired() => _isTimeExpired || _isConditionExpired;

  @override
  bool operator ==(Object other) {
    if (other is ExpiringField) {
      return id == other.id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;
}
