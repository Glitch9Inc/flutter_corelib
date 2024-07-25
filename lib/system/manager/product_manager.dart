import 'package:flutter_corelib/flutter_corelib.dart';

class ProductManager {
  static final ProductManager _instance = ProductManager._();
  ProductManager._();
  factory ProductManager() => _instance;

  static Future<String> Function(Product)? onGetPrice;
  static Future<Result<void>> Function(Product)? onPurchase;

  static void init(Future<Result<void>> Function(Product) onPurchase,
      Future<String> Function(Product) onGetPrice) {
    onPurchase = onPurchase;
  }

  static Future<Result<void>> purchaseProduct(Product product) async {
    if (onPurchase == null) return Result.fail('No purchase handler');
    return onPurchase!(product);
  }

  static Future<String> getPrice(Product product) async {
    if (onGetPrice == null) return '-';
    return onGetPrice!(product);
  }
}
