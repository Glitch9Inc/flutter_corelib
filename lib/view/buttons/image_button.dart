import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final String image;
  final double width;
  final double height;
  final Function onPressed;

  ImageButton(
      {required this.image,
      required this.width,
      required this.height,
      required this.onPressed});

  Widget _buildButton() {
    return Image.asset(
      image,
      width: width,
      height: height,
      fit: BoxFit.cover,
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
