import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class PopupCloseButton extends BasePopupCloseButton {
  const PopupCloseButton({
    super.key,
  });

  Widget _container() {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.outline,
        shape: BoxShape.circle,
        border: Border.all(
          color: Get.theme.colorScheme.surface,
          width: 2,
        ),
      ),
    );
  }

  Widget _image() {
    return Icon(
      Icons.close_sharp,
      color: Get.theme.colorScheme.surface,
      size: 24,
    );
  }

  @override
  Widget buildButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _container(),
        _image(),
      ],
    );
  }
}
