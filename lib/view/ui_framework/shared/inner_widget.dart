import 'package:flutter/material.dart';
import 'package:flutter_corelib/view/ui_framework/alert_dialog/dialog_action.dart';

abstract class InnerWidget extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final List<DialogAction>? actions;

  const InnerWidget({
    super.key,
    this.title = '',
    this.backgroundColor,
    this.actions,
  });
}
