import 'package:flutter/material.dart';
import 'package:flutter_corelib/ui/utils/clippers/diagonal_clipper.dart';

class ClippedContainer extends StatelessWidget {
  final double clipAngle;
  final String? overlayImage;
  final Color color;
  final Widget? child;
  final Gradient? gradient;
  final double? height;
  final BoxConstraints? constraints;

  const ClippedContainer({
    super.key,
    this.clipAngle = 0,
    this.overlayImage,
    this.color = Colors.transparent,
    this.gradient,
    this.height,
    this.child,
    this.constraints,
  });

  Decoration? _resolveDecoration() {
    if (overlayImage != null) {
      if (gradient != null) {
        return BoxDecoration(
          gradient: gradient,
          image: DecorationImage(
            image: AssetImage(overlayImage!),
            repeat: ImageRepeat.repeat,
          ),
        );
      } else {
        return BoxDecoration(
          color: color,
          image: DecorationImage(
            image: AssetImage(overlayImage!),
            repeat: ImageRepeat.repeat,
          ),
        );
      }
    }

    if (gradient != null) {
      return BoxDecoration(
        gradient: gradient,
        color: color,
      );
    }

    return BoxDecoration(
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      height: height,
      child: ClipPath(
        clipper: DiagonalClipper(angle: clipAngle),
        child: Container(
          decoration: _resolveDecoration(),
          child: child,
        ),
      ),
    );
  }
}
