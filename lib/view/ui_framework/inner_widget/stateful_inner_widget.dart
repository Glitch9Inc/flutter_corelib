import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

abstract class StatefulInnerWidget extends StatefulWidget with InnerWidgetMixin {
  @override
  final String title;
  @override
  final Color? backgroundColor;
  @override
  final List<DialogAction>? actions;

  const StatefulInnerWidget({
    super.key,
    this.title = '',
    this.backgroundColor,
    this.actions,
  });
}
