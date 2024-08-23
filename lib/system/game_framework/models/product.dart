import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

import 'iap_price_container.dart';

class Product {
  final String image;
  final String name;
  final String description;
  final int quantity;
  final Price price;
  final bool inAppPurchase;
  final String inAppPurchaseId;

  const Product({
    required this.image,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.description = '',
    this.inAppPurchase = false,
    this.inAppPurchaseId = '',
  });

  factory Product.sample() {
    return Product(
      image: 'assets/images/icons/ui/item/icon_key_gold.png',
      name: 'Sample Product',
      price: Price(
        10,
        name: 'Crystals',
        icon: 'assets/images/icons/ui/item/icon_gem01_blue.png',
      ),
    );
  }

  Future<Result<void>> purchase() async {
    if (inAppPurchase) {
      InAppPurchaseController iapController = Get.find();
      try {
        await iapController.buyProduct(inAppPurchaseId);
        return Result.successVoid();
      } catch (e) {
        return Result.fail(e.toString());
      }
    } else {
      try {
        //ViewManager.purchaseConfirmationDialog(product);
        return Result.successVoid();
      } catch (e) {
        return Result.fail(e.toString());
      }
    }
  }

  Future<String> getPrice() async {
    if (inAppPurchase) {
      InAppPurchaseController iapController = Get.find();
      return iapController.getPrice(inAppPurchaseId);
    } else {
      return 'error';
    }
  }

  Widget getPriceWidget({double size = 20}) {
    return inAppPurchase
        ? IAPPriceContainer(product: this, size: size)
        : price.toWidget(
            size: size,
            backgroundColor: Colors.black.withOpacity(0.5),
          );
  }
}
