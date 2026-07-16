class Expiration {
  final Duration duration;
  final DateTime expiresAt;

  Expiration(
    this.duration, {
    DateTime? expirationTime,
  }) : expiresAt = expirationTime ?? DateTime.now().add(duration);

  Expiration.expiresToday()
      : duration = const Duration(days: 1),
        expiresAt = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

  Expiration.expiresInDays(int days)
      : duration = Duration(days: days),
        expiresAt = DateTime.now().add(Duration(days: days));

  Expiration.expiresAt(this.expiresAt) : duration = expiresAt.difference(DateTime.now());

  bool isExpired() => DateTime.now().isAfter(expiresAt);

  void extend() => expiresAt.add(duration);
}
