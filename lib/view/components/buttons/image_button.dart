import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final String image;
  final double width;
  final double height;
  final Color? backgroundColor;
  final BoxDecoration? decoration;
  final Function onPressed;
  final BoxFit fit;

  const ImageButton({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    required this.onPressed,
    this.decoration,
    this.backgroundColor,
    this.fit = BoxFit.cover,
  });

  Widget _buildButton() {
    if (decoration != null) {
      return Container(
        width: width,
        height: height,
        decoration: decoration,
        child: Image.asset(
          image,
          fit: fit,
          width: width - 5,
          height: height - 5,
        ),
      );
    }

    if (backgroundColor != null) {
      return Container(
        width: width,
        height: height,
        color: backgroundColor,
        child: Image.asset(
          image,
          fit: fit,
          width: width - 5,
          height: height - 5,
        ),
      );
    }

    return Image.asset(
      image,
      width: width,
      height: height,
      fit: fit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: _buildButton(),
    );
  }
}
