import 'dart:math';

abstract class MyUuid {
  static const int nextInt = 10000;

  static String prefixed(String prefix) {
    // 일단 email과 같이 @가 있는 경우 @ 앞부분을 추출한다.
    var id = prefix.split('@').first;
    // 그리고 .을 모두 제거한다.
    id = id.replaceAll('.', '');
    // 그리고 모두 소문자로 변환한다.
    id = id.toLowerCase();
    // 그리고 뒤에 4자리 랜덤 숫자를 붙인다. (중복 방지)
    // 세퍼레이터는 _로 한다.
    id += '_${Random().nextInt(nextInt)}';
    return id;
  }

  static String v4() {
    final Random random = Random.secure();
    final List<int> uuid = List<int>.generate(16, (index) => random.nextInt(256));

    uuid[6] = (uuid[6] & 0x0F) | 0x40; // Set version to 4
    uuid[8] = (uuid[8] & 0x3F) | 0x80; // Set variant to RFC 4122

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < uuid.length; i++) {
      buffer.write(uuid[i].toRadixString(16).padLeft(2, '0'));
      if ([3, 5, 7, 9].contains(i)) {
        buffer.write('-');
      }
    }
    return buffer.toString();
  }
}
