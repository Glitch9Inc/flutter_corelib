import 'dart:math';

abstract class MyUuid {
  static String prefixed(String prefix, {int byteLength = 6}) {
    var id = prefix.split('@').first; // 일단 email과 같이 @가 있는 경우 @ 앞부분을 추출한다.
    id = id.replaceAll('.', ''); // 그리고 .을 모두 제거한다.
    id = id.toLowerCase();
    id += '_${_generateHexId(byteLength)}';
    return id;
  }

  static String _generateHexId(int byteLength) {
    final Random random = Random.secure();
    final List<int> bytes = List<int>.generate(byteLength, (index) => random.nextInt(256));
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join().substring(0, 6);
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
