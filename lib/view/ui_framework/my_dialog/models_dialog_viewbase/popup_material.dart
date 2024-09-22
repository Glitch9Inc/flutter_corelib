import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class PopupMaterial extends StatefulWidget {
  final Alignment? alignment;
  final EdgeInsets? padding;
  final Widget child;
  final bool animateScale;
  final bool animateOpacity;

  const PopupMaterial({
    super.key,
    required this.child,
    this.alignment,
    this.padding,
    this.animateScale = true,
    this.animateOpacity = true,
  });

  @override
  PopupMaterialState createState() => PopupMaterialState();
}

class PopupMaterialState extends State<PopupMaterial> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Widget _child;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _child = _resolveChild();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _container() {
    return Container(
      alignment: widget.alignment ?? Alignment.center,
      padding: widget.padding,
      child: widget.child,
    );
  }

  Widget _resolveChild() {
    if (widget.animateScale && widget.animateOpacity) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _container(),
        ),
      );
    } else if (widget.animateScale) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: _container(),
      );
    } else if (widget.animateOpacity) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: _container(),
      );
    } else {
      return _container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          const BlurLayer(),
          _child,
        ],
      ),
    );
  }
}
