import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

abstract class BaseDialogCloseButton extends StatelessWidget {
  final int dialogsToClose;
  final BorderRadius? inkWellBorderRadius;
  final CloseDialogCallback? closeDialogCallback;
  final VoidCallback? overrideOnClose;

  const BaseDialogCloseButton({
    super.key,
    this.closeDialogCallback,
    this.inkWellBorderRadius,
    this.dialogsToClose = 1,
    this.overrideOnClose,
  });

  Widget buildButton();

  void _onConfirm() {
    closeDialogCallback!.onConfirm();
    _close();
  }

  void _onCancel() {
    closeDialogCallback?.onCancel();
    _close();
  }

  void _close() {
    MyDialog.close(count: dialogsToClose, overrideOnClose: overrideOnClose);
  }

  void _onClose() {
    if (closeDialogCallback == null) {
      print('no close dialog callback');
      _close();
      return;
    }

    if (closeDialogCallback!.canClose()) {
      print('can close');
      _onConfirm();
      return;
    }

    print('cannot close');

    MyDialog.confirmationDialog(
      title: closeDialogCallback!.title,
      message: closeDialogCallback!.message,
      onPositive: _onConfirm,
      onNegative: _onCancel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: inkWellBorderRadius ?? BorderRadius.circular(100),
      onTap: _onClose,
      child: buildButton(),
    );
  }
}
