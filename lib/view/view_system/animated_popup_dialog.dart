import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

/// Only used for this project. Not recommended for general use.
class AnimatedPopupDialog extends StatefulWidget {
  final InnerWidget child;
  final double width;
  final VoidCallback? onDismiss;
  final MessageType messageType;

  const AnimatedPopupDialog({
    super.key,
    required this.child,
    required this.messageType,
    required this.width,
    this.onDismiss,
  });

  @override
  AnimatedPopupDialogState createState() => AnimatedPopupDialogState();
}

class AnimatedPopupDialogState extends State<AnimatedPopupDialog> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.onDismiss?.call();
    super.dispose();
  }

  void hide(VoidCallback callback) {
    if (mounted) {
      Future.microtask(() {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        callback(); // 콜백 호출
      });
    }
  }

  Expanded _buildPopupTitle(InnerWidget child) {
    TextAlign align = child.showCloseButton ? TextAlign.left : TextAlign.center;
    return Expanded(
      child: Text(
        child.title,
        style: Get.textTheme.headlineSmall!.copyWith(
          fontSize: 20,
        ),
        maxLines: 1,
        overflow: TextOverflow.clip,
        textAlign: align,
      ),
    );
  }

  Widget _buildPopupHeader(InnerWidget child) {
    if (child.hasHeader) {
      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 5, left: 25, right: 10),
        child: Row(
          children: [
            _buildPopupTitle(child),
            if (child.showCloseButton) const CloseButton(),
          ],
        ),
      );
    }

    return const SizedBox();
  }

  Color _resolveBackgroundColor() {
    if (widget.child.backgroundColor != null) {
      return widget.child.backgroundColor!;
    }
    switch (widget.messageType) {
      case MessageType.error: // 4a2247
        return const Color(0xff4a2247);
      case MessageType.warning: //4c3c19
        return const Color(0xff4c3c19);
      case MessageType.info: //193f4c
        return Get.theme.colorScheme.surfaceBright;
      case MessageType.success: //193f4c
        return const Color(0xff193f4c);
    }
  }

  Container _buildPopupContainer(InnerWidget child) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.only(bottom: 10),
      width: widget.width,
      decoration: BoxDecoration(
        color: _resolveBackgroundColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPopupHeader(child),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildPopupContainer(widget.child),
          ),
        ),
      ),
    );
  }
}
