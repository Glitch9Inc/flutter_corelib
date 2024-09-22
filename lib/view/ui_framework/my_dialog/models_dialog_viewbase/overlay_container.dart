import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class OverlayContainer extends StatelessWidget {
  final Widget child;
  final bool showCloseButton;
  final String? title;
  final List<Widget>? buttons;
  final double? width;
  final VoidCallback? onClose;

  const OverlayContainer({
    super.key,
    required this.child,
    this.showCloseButton = true,
    this.title,
    this.buttons,
    this.width,
    this.onClose,
  });

  bool get hasButtons => buttons != null && buttons!.isNotEmpty;

  Widget _circledCloseButton() {
    return GestureDetector(
        onTap: () {
          onClose?.call();
          MyDialog.close();
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            border: const Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
          ),
          child: const Center(
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.9,
      width: width ?? Get.width * 0.9,
      child: Stack(children: [
        if (title != null) ...[
          Padding(
            padding: EdgeInsets.only(bottom: Get.height * 0.6),
            child: Center(
                child: Text(
              title!,
              style: Get.textTheme.headlineSmall!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            )),
          ),
        ],
        Center(
          child: child,
        ),
        if (hasButtons) ...[
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buttons!,
            ),
          ),
        ] else if (showCloseButton) ...[
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: _circledCloseButton(),
          ),
        ],
      ]),
    );
  }
}
