class Expiration {
  final Duration duration;
  final DateTime expirationTime;

  Expiration(
    this.duration, {
    DateTime? expirationTime,
  }) : expirationTime = expirationTime ?? DateTime.now().add(duration);

  Expiration.expiresToday()
      : duration = const Duration(days: 1),
        expirationTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

  Expiration.expiresInDays(int days)
      : duration = Duration(days: days),
        expirationTime = DateTime.now().add(Duration(days: days));

  Expiration.expiresAt(this.expirationTime) : duration = expirationTime.difference(DateTime.now());

  bool isExpired() => DateTime.now().isAfter(expirationTime);

  void extend() => expirationTime.add(duration);
}
