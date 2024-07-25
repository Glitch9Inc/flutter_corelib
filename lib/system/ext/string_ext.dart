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

  // pascal 케이스를 스네이크 케이스로 변환
  String toSnakeCase() {
    return this.replaceAllMapped(RegExp(r'[A-Z]'), (match) {
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
}
