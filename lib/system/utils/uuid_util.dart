import 'dart:math';

abstract class UuidUtil {
  static String generateV4() {
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
