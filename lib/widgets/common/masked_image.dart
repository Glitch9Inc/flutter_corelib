import 'package:flutter/material.dart';

enum MaskingShape { circle, rectangle }

class MaskedImage extends StatelessWidget {
  final String imagePath;
  final MaskingShape maskingShape;

  const MaskedImage({super.key, required this.imagePath, required this.maskingShape});

  @override
  Widget build(BuildContext context) {
    switch (maskingShape) {
      case MaskingShape.circle:
        return ClipOval(
          child: Image.asset(
            imagePath,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        );
      case MaskingShape.rectangle:
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        );
    }
  }
}

// // 사용 예:
// Scaffold(
//   body: Center(
//     child: MaskedImage(
//       imagePath: 'assets/images/your_image.png',
//     ),
//   ),
// );
