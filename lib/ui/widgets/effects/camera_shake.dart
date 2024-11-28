import 'package:flutter/material.dart';
import 'dart:math';

class CameraShakeController {
  _CameraShakeState? _cameraShakeState;

  // ignore: library_private_types_in_public_api
  void attach(_CameraShakeState cameraShakeState) {
    _cameraShakeState = cameraShakeState;
  }

  void shake({
    Duration interval = const Duration(milliseconds: 500),
    double intensity = 10,
  }) {
    _cameraShakeState?.shake(interval: interval, intensity: intensity);
  }
}

class CameraShake extends StatefulWidget {
  final Widget child;
  final double intensity;
  final CameraShakeController controller;

  const CameraShake({
    super.key,
    required this.child,
    required this.controller,
    this.intensity = 10.0,
  });

  @override
  State<CameraShake> createState() => _CameraShakeState();
}

class _CameraShakeState extends State<CameraShake> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _intencity = 10;
  bool _isShaking = false;

  @override
  void initState() {
    super.initState();

    widget.controller.attach(this);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _intencity = widget.intensity;
    _animation = Tween<double>(begin: 0, end: _intencity).animate(_controller)
      ..addListener(() {
        if (_isShaking) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateIntensity(double intensity) {
    if (_intencity == intensity) {
      return;
    }
    _intencity = intensity;
    _animation = Tween<double>(begin: 0, end: _intencity).animate(_controller)
      ..addListener(() {
        if (_isShaking) {
          setState(() {});
        }
      });
  }

  double _randomShakeValue() {
    return Random().nextDouble() * _animation.value - _animation.value / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _isShaking ? Offset(_randomShakeValue(), _randomShakeValue()) : Offset.zero,
      child: widget.child,
    );
  }

  void shake({
    Duration interval = const Duration(milliseconds: 500),
    double intensity = 10,
  }) {
    if (_isShaking) return;

    _updateIntensity(intensity);
    _isShaking = true;
    _controller.repeat(reverse: true);
    Future.delayed(interval, () {
      _isShaking = false;
      _controller.stop();
      setState(() {}); // 상태를 갱신하여 흔들림이 없는 상태로 업데이트
    });
  }
}
