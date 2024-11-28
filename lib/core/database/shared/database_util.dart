import 'package:flutter_corelib/flutter_corelib.dart';

abstract class DatabaseUtil {
  static final Logger logger = Logger('');

  static void logInfo(String sender, String message) {
    logger.info(_parseLog(sender, message));
  }

  static void logWarning(String sender, String message) {
    logger.warning(_parseLog(sender, message));
  }

  static void logSevere(String sender, String message) {
    logger.severe(_parseLog(sender, message));
  }

  static String _parseLog(String sender, String message) {
    return '[$sender] $message';
  }

  /// 대부분의 경우 [변수명:타입] 형태로 작성되어 있으므로,
  /// 이를 파싱하여 변수명만 추출합니다.
  static String parseHeader(String header, [bool logResult = false]) {
    // example: id : string -> id
    // example(enum): mbtiType : Enum<MbtiType> -> mbtiType

    const space = ' ';
    String parsedHeader;

    if (header.contains(space)) {
      parsedHeader = header.split(space).first;
    } else {
      parsedHeader = header;
    }

    if (logResult) {
      logger.info('Parsed header: $parsedHeader');
    }

    return parsedHeader;
  }
}
