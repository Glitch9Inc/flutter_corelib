import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class DialogMessage extends InnerWidget {
  final String message;
  final MessageType messageType;
  final Widget? image;

  const DialogMessage({
    super.key,
    required super.title,
    required this.message,
    this.messageType = MessageType.info,
    this.image,
    super.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (image != null) ...[
          image!,
          const SizedBox(height: 10),
        ],
        IntrinsicHeight(
            child: Text(
          message,
          style: Get.theme.textTheme.bodyLarge!.copyWith(
            fontSize: 18,
            color: Get.theme.colorScheme.primary.desaturate(0.2).brighten(0.5),
          ),
          textAlign: TextAlign.center,
        )),
      ],
    );
  }
}
