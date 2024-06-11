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
}
