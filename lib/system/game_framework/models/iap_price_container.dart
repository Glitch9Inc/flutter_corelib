import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class IAPPriceContainer extends StatelessWidget {
  final double size;
  final double spacing;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Product product;

  const IAPPriceContainer({
    super.key,
    required this.product,
    this.size = 20,
    this.spacing = 3,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.backgroundColor = transparentBlackW500,
  });

  Container _buildContainer(String price) {
    double fontSize = size * 0.7;
    double horizontalPadding = size / 2;
    double verticalPadding = size / 4;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor,
      ),
      child: AutoSizeText(
        price,
        style: Get.textTheme.bodyMedium!.copyWith(fontSize: fontSize),
        maxLines: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: product.getPrice(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildContainer(snapshot.data!);
          } else {
            return _buildContainer('Loading...');
          }
        });
  }
}
