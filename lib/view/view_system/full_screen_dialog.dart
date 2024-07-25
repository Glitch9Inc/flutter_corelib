import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

/// Only used for this project. Not recommended for general use.
class FullScreenDialog extends StatefulWidget {
  final InnerWidget child;
  final Widget? background;
  const FullScreenDialog({super.key, required this.child, this.background});

  @override
  _FullScreenDialogState createState() => _FullScreenDialogState();
}

class _FullScreenDialogState extends State<FullScreenDialog> {
  Expanded _buildPopupTitle() {
    TextAlign align =
        widget.child.showCloseButton ? TextAlign.left : TextAlign.center;
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
          BackButton(),
          _buildPopupTitle(),
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
      body: Stack(
        children: [
          if (widget.child.backgroundEffect != null)
            Center(child: widget.child.backgroundEffect!),
          _buildColumn(),
        ],
      ),
    );
  }
}
