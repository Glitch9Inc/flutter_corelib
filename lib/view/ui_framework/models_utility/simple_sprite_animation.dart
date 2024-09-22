import 'package:flutter/widgets.dart';

class SimpleSpriteAnimation extends StatefulWidget {
  final List<String> imageAssets;
  final Duration frameDuration;
  final double? width;
  final double? height;
  final bool loop;
  final bool fadeBetweenFrames;

  const SimpleSpriteAnimation({
    super.key,
    required this.imageAssets,
    this.frameDuration = const Duration(milliseconds: 300),
    this.width,
    this.height,
    this.loop = true,
    this.fadeBetweenFrames = false,
  });

  @override
  State<SimpleSpriteAnimation> createState() => _SimpleSpriteAnimationState();
}

class _SimpleSpriteAnimationState extends State<SimpleSpriteAnimation> {
  int _currentFrame = 0;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startAnimation() {
    Future.delayed(widget.frameDuration, () {
      if (mounted) {
        setState(() {
          // Fade 효과를 적용해야 한다면, 먼저 투명도를 0으로 설정
          if (widget.fadeBetweenFrames) {
            _opacity = 0.0;
          }
        });

        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted) {
            setState(() {
              // 프레임 업데이트
              if (_currentFrame + 1 < widget.imageAssets.length) {
                _currentFrame += 1;
              } else if (widget.loop) {
                _currentFrame = 0; // 루프가 true일 때는 다시 첫 프레임으로
              } else {
                return; // 루프가 false일 때는 마지막 프레임에서 멈춤
              }

              // 투명도를 다시 1로 설정하여 다음 프레임을 보이게 함
              if (widget.fadeBetweenFrames) {
                _opacity = 1.0;
              }

              // 다시 애니메이션 시작
              _startAnimation();
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 200),
      child: Image.asset(
        widget.imageAssets[_currentFrame],
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}
