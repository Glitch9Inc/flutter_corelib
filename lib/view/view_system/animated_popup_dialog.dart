import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

/// Only used for this project. Not recommended for general use.
class AnimatedPopupDialog extends StatefulWidget {
  final InnerWidget child;
  final double width;
  const AnimatedPopupDialog(
      {super.key, required this.child, required this.width});

  @override
  _AnimatedPopupDialogState createState() => _AnimatedPopupDialogState();
}

class _AnimatedPopupDialogState extends State<AnimatedPopupDialog>
    with SingleTickerProviderStateMixin {
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
    super.dispose();
  }

  GestureDetector _buildBackground() {
    return GestureDetector(
      onTap: () {
        _controller.reverse();
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
        });
      },
      child: Container(
        color: Colors.black.withOpacity(.5),
      ),
    );
  }

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
      padding: const EdgeInsets.only(top: 10, bottom: 5, left: 25, right: 10),
      child: Row(
        children: [
          _buildPopupTitle(),
          if (widget.child.showCloseButton) CloseButton(),
        ],
      ),
    );
  }

  Container _buildPopupContainer() {
    return Container(
        width: widget.width,
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPopupHeader(),
            widget.child,
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          children: [
            _buildBackground(),
            if (widget.child.backgroundEffect != null)
              Center(child: widget.child.backgroundEffect!),
            Center(child: _buildPopupContainer()),
          ],
        ),
      ),
    );
  }
}
