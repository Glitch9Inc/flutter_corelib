import 'package:flutter_corelib/flutter_corelib.dart';

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
}
