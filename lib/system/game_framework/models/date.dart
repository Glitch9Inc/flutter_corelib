class Date {
  final int year;
  final int month;
  final int day;

  Date({required this.year, required this.month, required this.day});
  factory Date.create(int year, int month, int day) {
    return Date(year: year, month: month, day: day);
  }

  @override
  String toString() {
    return '$year-$month-$day';
  }

  // DateTime 객체로 변환하는 메소드
  DateTime toDateTime() {
    return DateTime(year, month, day);
  }

  // DateTime 객체에서 DateOnly 객체로 변환하는 정적 메소드
  static Date fromDateTime(DateTime dateTime) {
    return Date.create(dateTime.year, dateTime.month, dateTime.day);
  }

  // 현재 날짜를 가져오는 정적 메소드
  static Date today() {
    final now = DateTime.now();
    return Date.create(now.year, now.month, now.day);
  }

  @override
  bool operator ==(Object other) {
    if (other is Date) {
      return year == other.year && month == other.month && day == other.day;
    }
    return false;
  }

  @override
  int get hashCode => year.hashCode ^ month.hashCode ^ day.hashCode;

  // 날짜를 비교하는 메소드
  int compareTo(Date other) {
    if (year != other.year) {
      return year - other.year;
    } else if (month != other.month) {
      return month - other.month;
    } else {
      return day - other.day;
    }
  }

  // 날짜를 더하는 메소드
  Date addDays(int days) {
    final dateTime = toDateTime().add(Duration(days: days));
    return Date.create(dateTime.year, dateTime.month, dateTime.day);
  }

  // 날짜를 빼는 메소드
  Date subtractDays(int days) {
    final dateTime = toDateTime().subtract(Duration(days: days));
    return Date.create(dateTime.year, dateTime.month, dateTime.day);
  }

  // 날짜 차이를 구하는 메소드
  int difference(Date other) {
    final thisDateTime = toDateTime();
    final otherDateTime = other.toDateTime();
    return thisDateTime.difference(otherDateTime).inDays;
  }

  // 날짜가 이전인지 확인하는 메소드
  bool isBefore(Date other) {
    return toDateTime().isBefore(other.toDateTime());
  }

  // 날짜가 이후인지 확인하는 메소드
  bool isAfter(Date other) {
    return toDateTime().isAfter(other.toDateTime());
  }
}