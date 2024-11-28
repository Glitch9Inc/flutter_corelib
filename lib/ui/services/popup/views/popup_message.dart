import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class PopupMessage extends StatefulWidget {
  final String title;
  final Color? backgroundColor;
  final List<PopupAction>? actions;
  final String? message;
  final List<TextSpan>? messageSpans;
  final MessageType messageType;
  final Widget? image;
  final int? buttonsInRow;
  final bool reverseButtons;

  final VoidCallback? onClose;

  const PopupMessage({
    super.key,
    required this.title,
    this.message,
    this.messageSpans,
    this.messageType = MessageType.info,
    this.image,
    this.actions,
    this.onClose,
    this.backgroundColor,
    this.buttonsInRow,
    this.reverseButtons = false,
  });

  @override
  State<StatefulWidget> createState() => PopupMessageState();
}

class PopupMessageState extends State<PopupMessage> {
  @override
  void dispose() {
    widget.onClose?.call();
    super.dispose();
  }

  Color _resolveBackgroundColor() {
    switch (widget.messageType) {
      case MessageType.success:
        return darkModeGreenW500;
      case MessageType.warning:
        return darkModeYellowW500;
      case MessageType.error:
        return darkModeRedW500;
      default:
        return darkModeIndigoW700;
    }
  }

  Widget _buildImage() {
    if (widget.image != null) {
      return widget.image!;
    } else {
      return Container();
    }
  }

  Widget _buildTitle(Color bgColor) {
    return StrokeText(
      widget.title,
      style: Get.textTheme.headlineSmall,
      textAlign: TextAlign.center,
      strokeStyle: StrokeStyle(
        type: StrokeType.shadow,
        color: bgColor.darken(0.1),
      ),
    );
  }

  Widget _buildMessage(Color bgColor) {
    if (widget.message != null) {
      return StrokeText(
        widget.message!,
        style: Get.textTheme.bodyLarge,
        textAlign: TextAlign.center,
        strokeStyle: StrokeStyle(
          type: StrokeType.shadow,
          color: bgColor.darken(0.1),
        ),
      );
    }

    if (widget.messageSpans != null) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Get.textTheme.bodyLarge,
          children: widget.messageSpans!,
        ),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _resolveBackgroundColor();
    final buttonsInRow = widget.buttonsInRow ?? 2;
    final actionsInOrder = widget.reverseButtons ? widget.actions?.reversed : widget.actions;

    return PopupBase(
      showCloseButton: false,
      padding: const EdgeInsets.all(20),
      backgroundColor: bgColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildImage(),
          const SizedBox(height: 10),
          _buildTitle(bgColor),
          const SizedBox(height: 10),
          _buildMessage(bgColor),
          const SizedBox(height: 30),
          if (widget.actions != null) ...[
            Wrap(
              spacing: 10, // 버튼 간 가로 간격
              runSpacing: 10, // 버튼 간 세로 간격
              alignment: WrapAlignment.center,
              children: actionsInOrder!.map((action) {
                return SizedBox(
                  width: Get.width / buttonsInRow - 60, // 버튼 폭 동적 계산
                  child: EasyButton(
                    text: action.text,
                    onPressed: action.onPressed,
                    color: action.color ?? WidgetColor.blue,
                  ),
                );
              }).toList(),
            ),
          ] else ...[
            EasyButton(
              text: 'Close',
              width: 140,
              onPressed: () {
                Popup.close();
                widget.onClose?.call();
              },
            ),
          ],
        ],
      ),
    );
  }
}
