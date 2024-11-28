import 'package:flutter/material.dart';

class AnimatedGestureDetector extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  final Duration duration;
  final double targetScale;
  final double targetOffsetY;

  const AnimatedGestureDetector({
    super.key,
    required this.onTap,
    required this.child,
    this.duration = const Duration(milliseconds: 100),
    this.targetScale = 1.0,
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
      child: AnimatedContainer(
        duration: widget.duration,
        alignment: Alignment.center, // 중앙 기준으로 스케일 애니메이션 적용
        transform: _isPressed
            ? Matrix4.translationValues(0, _targetOffsetY, 0) * Matrix4.diagonal3Values(_targetScale, _targetScale, 1)
            : Matrix4.identity(),
        child: widget.child,
      ),
    );
  }
}
