import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

abstract class ImageUtil {
  static Future<ui.Image> loadImage(String asset) async {
    final ByteData data = await rootBundle.load(asset);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }
}
