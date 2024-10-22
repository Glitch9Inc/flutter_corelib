import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class DialogMessage extends StatefulWidget {
  final String title;
  final Color? backgroundColor;
  final List<DialogAction>? actions;
  final String message;
  final MessageType messageType;
  final Widget? image;
  final VoidCallback? onClose;

  const DialogMessage({
    super.key,
    required this.title,
    required this.message,
    this.messageType = MessageType.info,
    this.image,
    this.actions,
    this.onClose,
    this.backgroundColor,
  });

  @override
  State<StatefulWidget> createState() => DialogMessageState();
}

class DialogMessageState extends State<DialogMessage> {
  @override
  void dispose() {
    widget.onClose?.call();
    super.dispose();
  }

  Color _resolveBackgroundColor() {
    switch (widget.messageType) {
      case MessageType.success:
        return routinaGreenW500;
      case MessageType.warning:
        return routinaYellowW500;
      case MessageType.error:
        return routinaRedW500;
      default:
        return routinaIndigoW700;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = _resolveBackgroundColor();

    return PopupContainer(
      // title: widget.title,
      showCloseButton: false,
      padding: const EdgeInsets.all(20),
      backgroundColor: bgColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.image != null) ...[
            widget.image!,
            const SizedBox(height: 10),
          ],
          StrokeText(
            widget.title,
            style: Get.textTheme.headlineSmall,
            textAlign: TextAlign.center,
            strokeStyle: StrokeStyle(
              type: StrokeType.shadow,
              color: bgColor.darken(0.1),
            ),
          ),
          const SizedBox(height: 10),
          StrokeText(
            widget.message,
            style: Get.theme.textTheme.bodyLarge!.copyWith(
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            strokeStyle: StrokeStyle(
              type: StrokeType.shadow,
              color: bgColor.darken(0.1),
            ),
          ),
          const SizedBox(height: 30),
          if (widget.actions != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.actions!.map((action) {
                return EasyButton(
                  text: action.text,
                  width: 140,
                  onPressed: action.onPressed,
                  uiColor: action.uiColor ?? UIColor.blue,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                );
              }).toList(),
            ),
          ] else ...[
            EasyButton(
              text: 'Close',
              width: 140,
              onPressed: () {
                MyDialog.close();
                widget.onClose?.call();
              },
            ),
          ],
        ],
      ),
    );
  }
}
