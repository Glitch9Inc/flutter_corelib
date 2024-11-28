import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ScaledSwitch extends Switch {
  final double scale;

  const ScaledSwitch({
    super.key,
    this.scale = 0.8,
    required super.value,
    required super.onChanged,
    super.activeColor,
    super.activeTrackColor,
    super.inactiveThumbColor,
    super.inactiveTrackColor,
    super.activeThumbImage,
    super.onActiveThumbImageError,
    super.inactiveThumbImage,
    super.onInactiveThumbImageError,
    super.thumbColor,
    super.trackColor,
    super.trackOutlineColor,
    super.trackOutlineWidth,
    super.thumbIcon,
    super.materialTapTargetSize,
    super.dragStartBehavior = DragStartBehavior.start,
    super.mouseCursor,
    super.focusColor,
    super.hoverColor,
    super.overlayColor,
    super.splashRadius,
    super.focusNode,
    super.onFocusChange,
    super.autofocus = false,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: super.build(context),
    );
  }
}
