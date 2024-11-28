import 'dart:convert';

import 'package:flutter/material.dart';

extension StringExt on String {
  get imageIcon32 => Image(
        image: AssetImage(this),
        width: 32,
        height: 32,
        fit: BoxFit.scaleDown,
        alignment: FractionalOffset.center,
      );

  get imageIcon36 => Image(
        image: AssetImage(this),
        width: 36,
        height: 36,
        fit: BoxFit.scaleDown,
        alignment: FractionalOffset.center,
      );

  get imageIcon48 => Image(
        image: AssetImage(this),
        width: 48,
        height: 48,
        fit: BoxFit.scaleDown,
        alignment: FractionalOffset.center,
      );

  get green => '\x1B[32m$this\x1B[0m';
  get yellow => '\x1B[33m$this\x1B[0m';
  get red => '\x1B[31m$this\x1B[0m';
  get blue => '\x1B[34m$this\x1B[0m';

  String colorize(Color color) {
    return '\x1B[38;2;${color.red};${color.green};${color.blue}m$this\x1B[0m';
  }

  // pascal 케이스를 스네이크 케이스로 변환
  String toSnakeCase() {
    return replaceAllMapped(RegExp(r'[A-Z]'), (match) {
      return '_${match.group(0)!.toLowerCase()}';
    });
  }

  bool get canBeParsedToJson {
    try {
      final _ = jsonDecode(this);

      return true;
    } catch (e) {
      return false;
    }
  }

  int toInt() {
    return int.parse(this);
  }

  String colorNumbers(Color color) {
    // 숫자부분을 찾아야한다.
    // 숫자 사이에 ','가 있을 수도 있고 없을 수도 있다.
    // 특이사항: 'once'는 숫자로 취급한다.

    final regex = RegExp(r'(\d{1,3}(,\d{3})*|\bonce\b)');
    final matches = regex.allMatches(this);

    String result = this;

    for (final match in matches) {
      final number = match.group(0)!;

      result = result.replaceFirst(number, number.colorize(color));
    }

    return result;
  }

  String format(List<String> args) {
    String result = this;

    for (int i = 0; i < args.length; i++) {
      result = result.replaceAll('{$i}', args[i]);
    }

    return result;
  }
}
