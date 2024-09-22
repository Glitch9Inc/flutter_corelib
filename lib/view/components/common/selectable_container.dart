import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class SelectableContainer extends StatelessWidget {
  // Custom properties
  final bool isSelected;
  final Widget? selectedWidget;

  // Container properties
  final Widget? child;
  final Matrix4? transform;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final EdgeInsetsGeometry? margin;
  final Clip clipBehavior;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BoxConstraints? constraints;
  final AlignmentGeometry? transformAlignment;
  final double? width;
  final double? height;

  const SelectableContainer({
    super.key,
    required this.isSelected,
    this.selectedWidget,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.child,
    this.clipBehavior = Clip.none,
  });

  Container _container({Widget? childParam, Decoration? decorationParam}) {
    return Container(
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decorationParam ?? decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: childParam,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: _container(
            childParam: child,
          ),
        ),
        if (isSelected)
          Positioned.fill(
            child: selectedWidget ??
                _container(
                    decorationParam: BoxDecoration(
                  border: Border.all(color: routinaGreenW300, width: 2),
                  borderRadius: (decoration is BoxDecoration) ? (decoration as BoxDecoration).borderRadius : null,
                )),
          ),
      ],
    );
  }
}
