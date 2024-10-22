import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

abstract class QuickLoading {
  static Widget loadingWidget = const QuickLoadingWidget();

  static void set(bool value) {
    value ? show() : hide();
  }

  static void show() {
    MyDialog.showOverlay(loadingWidget, showCloseButton: false);
  }

  static void hide() {
    MyDialog.close(ignoreOnClose: true);
  }
}

class QuickLoadingWidget extends StatelessWidget {
  final Color backgroundColor;
  const QuickLoadingWidget({super.key, this.backgroundColor = transparentBlackW100});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: const Center(
        // TODO: 로딩애니메이션 외주줘서 커스텀하기
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}
