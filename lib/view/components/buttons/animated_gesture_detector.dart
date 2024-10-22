import 'package:flutter/material.dart';

class AnimatedGestureDetector extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  final double width;
  final double height;
  final Color color;
  final Duration duration;
  final double targetScale;
  final double targetOffsetY;

  const AnimatedGestureDetector({
    super.key,
    required this.onTap,
    required this.child,
    this.width = 200,
    this.height = 50,
    this.color = Colors.blue,
    this.duration = const Duration(milliseconds: 100),
    this.targetScale = 0.8,
    this.targetOffsetY = 2.5,
  });

  @override
  State<AnimatedGestureDetector> createState() => _AnimatedGestureDetectorState();
}

class _AnimatedGestureDetectorState extends State<AnimatedGestureDetector> {
  static const double _tappingMultiplier = 0.5;
  late double _targetScale;
  late double _tappingTargetScale;
  late double _targetOffsetY;
  late double _tappingOffsetY;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _targetScale = widget.targetScale;
    double scaleChg = 1 - _targetScale;
    _tappingTargetScale = _targetScale - (scaleChg * _tappingMultiplier);
    _targetOffsetY = widget.targetOffsetY;
    _tappingOffsetY = _targetOffsetY * _tappingMultiplier;
  }

  void _setIsPressed(bool value) {
    if (mounted) {
      setState(() {
        _isPressed = value;
      });
    }
  }

  void _onTap() {
    if (mounted) {
      setState(() {
        _targetScale = _tappingTargetScale;
        _targetOffsetY = _tappingOffsetY;
        widget.onTap();
        _setIsPressed(true);
        Future.delayed(widget.duration, () {
          _setIsPressed(false);
          _targetScale = widget.targetScale;
          _targetOffsetY = widget.targetOffsetY;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setIsPressed(true),
      onTapUp: (_) => _setIsPressed(false),
      onTapCancel: () => _setIsPressed(false),
      onTap: _onTap,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedContainer(
          duration: widget.duration,
          width: _isPressed ? widget.width * _targetScale : widget.width,
          height: _isPressed ? widget.height * _targetScale : widget.height,
          transform: _isPressed ? Matrix4.translationValues(0, _targetOffsetY, 0) : Matrix4.identity(),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
