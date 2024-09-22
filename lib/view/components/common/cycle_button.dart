import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class CycleButton extends StatefulWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? color;
  final UIColor uiColor;
  final BorderDirection borderDirection;

  final List<ItemEntry> values;
  final WidgetDisplayOption displayOption;
  final Function(int) onToggle;

  const CycleButton({
    super.key,
    required this.values,
    required this.onToggle,
    this.displayOption = WidgetDisplayOption.showAll,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
    this.padding,
    this.color,
    this.uiColor = UIColor.blue,
    this.borderDirection = BorderDirection.all,
  });

  @override
  State<CycleButton> createState() => _CycleButtonState();
}

class _CycleButtonState extends State<CycleButton> {
  int _selectedIndex = 0;

  void _onToggle() {
    setState(() {
      int count = widget.values.length;

      if (_selectedIndex < count - 1) {
        _selectedIndex++;
      } else {
        _selectedIndex = 0;
      }

      widget.onToggle(_selectedIndex);
    });
  }

  Widget _resolveWidget() {
    Widget? iconWidget;
    if (widget.displayOption == WidgetDisplayOption.showAll || widget.displayOption == WidgetDisplayOption.iconOnly) {
      iconWidget = widget.values[_selectedIndex].icon;
    }

    String? text;
    if (widget.displayOption == WidgetDisplayOption.showAll || widget.displayOption == WidgetDisplayOption.textOnly) {
      text = widget.values[_selectedIndex].name;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconWidget != null) ...[
          iconWidget,
          if (text != null) const SizedBox(width: 10),
        ],
        if (text != null) Text(text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onToggle,
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: widget.padding,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: widget.color ?? widget.uiColor.lightColor,
          borderRadius: widget.borderDirection.resolveBorderRadius(widget.borderRadius),
        ),
        child: _resolveWidget(),
      ),
    );
  }
}
