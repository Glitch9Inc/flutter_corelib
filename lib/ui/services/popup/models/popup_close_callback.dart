import 'dart:ui';

import 'package:flutter_corelib/flutter_corelib.dart';

/// 조건부에따라 확인 dialog를 띄울 수 있는 특수한 콜백
class PopupCloseCallback {
  final String title;
  final String message;
  final bool Function() canClose;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  PopupCloseCallback({
    required this.title,
    required this.message,
    required this.canClose,
    required this.onConfirm,
    required this.onCancel,
  });

  factory PopupCloseCallback.hasChanges({
    required bool Function() canClose,
    required VoidCallback onDoSave,
    VoidCallback? onDontSave,
  }) {
    return PopupCloseCallback(
      title: 'Unsaved Changes',
      message: 'You have unsaved changes. Do you want to save the changes before closing?',
      canClose: canClose,
      onConfirm: () {
        onDoSave();
        Popup.close(count: 2);
      },
      onCancel: () {
        onDontSave?.call();
        Popup.close(count: 2);
      },
    );
  }
}
