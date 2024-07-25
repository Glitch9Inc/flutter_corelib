import 'package:flutter_corelib/flutter_corelib.dart';

class Product {
  final String image;
  final String name;
  final String description;
  final int quantity;
  final Price price;
  final bool inAppPurchase;
  final String inAppPurchaseId;

  final Future<void> Function(Product) onPurchase =
      ProductManager.purchaseProduct;
  final Future<String> Function(Product) onGetPrice = ProductManager.getPrice;

  const Product({
    required this.image,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.description = '',
    this.inAppPurchase = false,
    this.inAppPurchaseId = '',
  });

  Future<void> purchase() async {
    await onPurchase(this);
  }

  Future<String> getPrice() async {
    return await onGetPrice(this);
  }
}
