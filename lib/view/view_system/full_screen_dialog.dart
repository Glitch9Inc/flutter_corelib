import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

/// Only used for this project. Not recommended for general use.
class FullScreenDialog extends StatefulWidget {
  final InnerWidget child;
  final VoidCallback? onDismiss;
  final Widget? background;
  const FullScreenDialog({super.key, required this.child, this.background, this.onDismiss});

  @override
  State<FullScreenDialog> createState() => _FullScreenDialogState();
}

class _FullScreenDialogState extends State<FullScreenDialog> {
  Expanded _buildPopupTitle() {
    TextAlign align = widget.child.showCloseButton ? TextAlign.left : TextAlign.center;
    return Expanded(
      child: Text(
        widget.child.title,
        style: Get.textTheme.headlineSmall,
        maxLines: 1,
        overflow: TextOverflow.clip,
        textAlign: align,
      ),
    );
  }

  Padding _buildPopupHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 5,
      ),
      child: Row(
        children: [
          BackButton(
              onPressed: () => {
                    widget.onDismiss?.call(),
                    Get.back(),
                  }),
          _buildPopupTitle(),
          if (widget.child.button != null) widget.child.button!,
        ],
      ),
    );
  }

  Column _buildColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPopupHeader(),
        Expanded(
          child: widget.child,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return EasyScaffold(
      background: widget.background,
      backgroundColor: Colors.transparent,
      body: _buildColumn(),
    );
  }
}
