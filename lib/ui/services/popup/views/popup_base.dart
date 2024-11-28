import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class PopupBase extends StatelessWidget {
  final String? title;
  final TextAlign titleAlign;
  final Widget? child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final bool showCloseButton;
  final Color? backgroundColor;
  final Widget? footer;

  const PopupBase({
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
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final finalBackgroundColor = backgroundColor ?? Get.theme.colorScheme.surfaceBright;
    final finalPadding = padding ?? const EdgeInsets.all(15);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: margin,
          padding: finalPadding,
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: finalBackgroundColor,
            borderRadius: BorderRadius.circular(30),
            border: BorderExt.top(3, transparentWhiteW100, includeSides: false),
            boxShadow: getCastShadow(color: finalBackgroundColor.darken(0.1)),
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
                      type: StrokeType.shadow,
                      color: finalBackgroundColor.darken(0.1),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (child != null) child!,
              if (footer != null) ...[
                const SizedBox(height: 10),
                footer!,
              ],
            ],
          ),
        ),
        if (showCloseButton) ...[
          Positioned(
            top: -12,
            right: -12,
            child: Popup.closeButton,
          ),
        ],
      ],
    );
  }
}
