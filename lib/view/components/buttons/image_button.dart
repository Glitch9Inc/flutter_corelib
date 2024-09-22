import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class ImageButton extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final Color? color;
  final Color disabledColor;
  final VoidCallback? onPressed;
  final BoxFit fit;
  final bool interactable;

  const ImageButton({
    super.key,
    required this.imagePath,
    required this.onPressed,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.interactable = true,
    this.disabledColor = routinaDisabledBorder,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        if (interactable) {onPressed?.call()}
      },
      borderRadius: BorderRadius.circular(100),
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: Image.asset(
            imagePath,
            color: interactable ? color : disabledColor,
            fit: fit,
          ),
        ),
      ),
    );
  }
}
