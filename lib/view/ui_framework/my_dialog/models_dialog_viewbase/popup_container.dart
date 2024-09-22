import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class PopupContainer extends StatelessWidget {
  final String? title;
  final TextAlign titleAlign;
  final Widget? child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final bool showCloseButton;
  final Color? backgroundColor;

  const PopupContainer({
    super.key,
    this.title,
    this.titleAlign = TextAlign.center,
    this.child,
    this.margin,
    this.padding,
    this.showCloseButton = false,
    this.height,
    this.width,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = backgroundColor ?? Get.theme.colorScheme.surfaceBright;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: margin,
          padding: padding,
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(30),
            border: BorderExt.top(3, transparentWhiteW100, includeSides: false),
            boxShadow: getCartoonBoxShadow(color: bgColor.darken(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                Align(
                  alignment: titleAlign.alignment,
                  child: StrokeText(
                    title!,
                    style: Get.textTheme.headlineSmall,
                    textAlign: titleAlign,
                    maxLines: 1,
                    minFontSize: 10,
                    strokeStyle: StrokeStyle(
                      type: StrokeType.blurred,
                      color: bgColor.darken(0.1),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              child!,
            ],
          ),
        ),
        if (showCloseButton) ...[
          Positioned(
            top: -12,
            right: -12,
            child: MyDialog.closeButton,
          ),
        ],
      ],
    );
  }
}
