import 'package:intl/intl.dart';

enum StringFormat {
  key, // 'sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'
  short, // 'M'
  abbreviated, // 'Mon'
  full, // 'Monday'
  kanji, // "月, 火, 水, 木, 金, 土, 日"
}

extension StringFormatExtension on StringFormat {
  // String formatWeekday(int weekday) {
  //   const key = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'];
  //   const short = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  //   const abbreviated = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  //   const full = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  //   const kanji = ['日', '月', '火', '水', '木', '金', '土'];

  //   switch (this) {
  //     case StringFormat.short:
  //       return short[weekday % 7];
  //     case StringFormat.abbreviated:
  //       return abbreviated[weekday % 7];
  //     case StringFormat.full:
  //       return full[weekday % 7];
  //     case StringFormat.kanji:
  //       return kanji[weekday % 7];
  //     default:
  //       return key[weekday % 7];
  //   }
  // }

  String formatWeekday(int weekday) {
    // 요일 값을 0 ~ 6 범위로 보정 (0: Sunday)
    final adjustedWeekday = weekday % 7;

    // 현재 Locale에 따라 기본 요일 이름 가져오기
    final date = DateTime(2023, 1, 1 + adjustedWeekday); // 2023년 1월 1일은 일요일
    final abbreviated = DateFormat.E().format(date); // 예: Sun
    final full = DateFormat.EEEE().format(date); // 예: Sunday

    // 한자 요일 (일본어 고정)
    const kanji = ['日', '月', '火', '水', '木', '金', '土'];
    const keys = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'];

    switch (this) {
      case StringFormat.key:
        return keys[adjustedWeekday];
      case StringFormat.short:
        return abbreviated.isEmpty ? '' : abbreviated.substring(0, 1);
      case StringFormat.abbreviated:
        return abbreviated;
      case StringFormat.full:
        return full; // Locale에 맞는 전체 이름
      case StringFormat.kanji:
        return kanji[adjustedWeekday]; // 한자는 고정 값 사용
    }
  }
}
