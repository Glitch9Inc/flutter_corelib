class Stamina {
  /// ~분에 1씩 회복되는지 param
  final int recoveryTimeMinute = 5;

  /// 1레벨일때 최대 스태미너
  final int startingMaxStamina = 100;

  /// 1레벨마다 증가하는 최대 스태미너 양
  final int maxStaminaIncreasePerLevel = 5;

  /// 현재 유저 레벨
  final int userLevel; // 최소 레벨

  /// 마지막 스테미너 값
  int lastStaminaValue;

  /// 마지막 스테미너 사용 시간
  DateTime lastStaminaUseTime;

  Stamina({
    required this.userLevel,
    required this.lastStaminaValue,
    required this.lastStaminaUseTime,
  });

  int get maxValue {
    return startingMaxStamina + (userLevel - 1) * maxStaminaIncreasePerLevel;
  }

  /// 현재 스테미너
  int get value {
    final now = DateTime.now();
    final elapsedTime = now.difference(lastStaminaUseTime).inMinutes;
    final recoveredStamina = elapsedTime ~/ recoveryTimeMinute;
    final currentStamina = lastStaminaValue + recoveredStamina;
    return currentStamina.clamp(0, maxValue);
  }

  /// 스테미너 사용
  void useStamina(int amount) {
    lastStaminaValue = value - amount;
    lastStaminaUseTime = DateTime.now();
  }
}
