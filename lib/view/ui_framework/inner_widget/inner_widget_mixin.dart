import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

mixin InnerWidgetMixin on Widget {
  String get title;
  Color? get backgroundColor;
  List<DialogAction>? get actions;
}
