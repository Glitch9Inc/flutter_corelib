import 'package:flutter/material.dart';
import 'package:flutter_corelib/ui/flutter_corelib_ui.dart';

class TransitionUtil {
  static RouteTransitionsBuilder slideTransition(TweenDirection tweenDirection) {
    return (context, animation, secondaryAnimation, child) {
      var begin = getOffset(tweenDirection);
      var secondaryEnd = getSecondaryOffset(tweenDirection);
      var end = Offset.zero;
      var curve = Curves.ease;

      // 메인 애니메이션
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      // 이전 화면의 애니메이션
      var secondaryTween = Tween(begin: Offset.zero, end: secondaryEnd).chain(CurveTween(curve: curve));
      var secondaryOffsetAnimation = secondaryAnimation.drive(secondaryTween);

      return Stack(
        children: [
          SlideTransition(
            position: secondaryOffsetAnimation, // 이전 화면 애니메이션
            child: Container(color: Colors.black.withOpacity(0.1)), // 이전 화면의 배경
          ),
          SlideTransition(
            position: offsetAnimation, // 새 화면 애니메이션
            child: child,
          ),
        ],
      );
    };
  }

  static Offset getOffset(TweenDirection tweenDirection) {
    switch (tweenDirection) {
      case TweenDirection.toLeft:
        return const Offset(1.0, 0.0);
      case TweenDirection.toRight:
        return const Offset(-1.0, 0.0);
      case TweenDirection.toUp:
        return const Offset(0.0, -1.0);
      case TweenDirection.toDown:
        return const Offset(0.0, 1.0);
    }
  }

  static Offset getSecondaryOffset(TweenDirection tweenDirection) {
    switch (tweenDirection) {
      case TweenDirection.toLeft:
        return const Offset(-1.0, 0.0);
      case TweenDirection.toRight:
        return const Offset(1.0, 0.0);
      case TweenDirection.toUp:
        return const Offset(0.0, 1.0);
      case TweenDirection.toDown:
        return const Offset(0.0, -1.0);
    }
  }
}
