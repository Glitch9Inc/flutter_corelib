import 'package:flutter/material.dart';
import 'dart:ui';

class BlurLayer extends StatefulWidget {
  final double blurStrength;

  const BlurLayer({
    super.key,
    this.blurStrength = 5.0, // 기본 블러 강도 설정
  });

  @override
  BlurLayerState createState() {
    return BlurLayerState();
  }
}

class BlurLayerState extends State<BlurLayer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0.0, end: widget.blurStrength).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    Future.delayed(const Duration(milliseconds: 100), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _animation.value,
              sigmaY: _animation.value,
            ),
            child: Container(
              color: Colors.transparent, // 필터가 적용된 위젯을 클릭 가능하게 만듦
            ),
          );
        },
      ),
    );
  }
}
