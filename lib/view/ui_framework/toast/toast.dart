import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:get/get.dart';

abstract class Toast {
  static void makeText(
    String message, {
    Widget? icon,
    Duration duration = const Duration(seconds: 5),
    Alignment alignment = Alignment.bottomCenter,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 200.0),
  }) {
    // Get the global overlay context using GetX
    final overlayContext = Get.overlayContext;

    if (overlayContext != null) {
      final overlay = Overlay.of(overlayContext);

      final overlayEntry = OverlayEntry(
        builder: (context) {
          return ToastWidget(
            message: message,
            alignment: alignment,
            icon: icon,
            padding: padding,
          );
        },
      );

      overlay.insert(overlayEntry);

      Future.delayed(duration, () {
        overlayEntry.remove();
      });
    }
  }
}

class ToastWidget extends StatefulWidget {
  final String message;
  final Widget? icon;
  final Alignment alignment;
  final EdgeInsetsGeometry padding;

  const ToastWidget({
    super.key,
    required this.message,
    required this.alignment,
    this.icon,
    this.padding = const EdgeInsets.symmetric(vertical: 100.0),
  });

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 1), () {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: Padding(
        padding: widget.padding,
        child: Material(
          color: Colors.transparent,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: IntrinsicWidth(
              child: Container(
                padding: EdgeInsets.only(left: widget.icon == null ? 24.0 : 18.0, right: 24.0, top: 12.0, bottom: 12.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    if (widget.icon != null) ...[
                      widget.icon!,
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.message,
                      style: Get.textTheme.bodyMedium!.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
