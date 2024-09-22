import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

abstract class Loading {
  static Widget loadingWidget = const LoadingWidget();

  static void set(bool value) {
    if (value) {
      show();
    } else {
      hide();
    }
  }

  static void show() {
    MyDialog.showOverlay(loadingWidget, showCloseButton: false);
  }

  static void hide() {
    MyDialog.close(ignoreOnClose: true);
  }
}

class LoadingWidget extends StatelessWidget {
  final double backgroundOpacity;
  const LoadingWidget({super.key, this.backgroundOpacity = 0.5});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(backgroundOpacity), // transparentBlackW500 유사 색상
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}
