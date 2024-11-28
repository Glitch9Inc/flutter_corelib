import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class EasyCheckbox extends StatefulWidget {
  // Data
  final bool initialValue;
  final void Function(bool) onChanged;

  // UI Components
  final String? labelText;
  final TextStyle? textStyle;
  final Decoration? boxDecoration;
  final Widget? check;
  final EdgeInsets? padding;
  final double? size;

  const EasyCheckbox({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.labelText,
    this.textStyle,
    this.boxDecoration,
    this.check,
    this.padding,
    this.size,
  });

  @override
  EasyCheckboxState createState() => EasyCheckboxState();
}

class EasyCheckboxState extends State<EasyCheckbox> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
          widget.onChanged(_isChecked);
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: widget.padding ?? const EdgeInsets.all(4),
            width: widget.size ?? 24,
            height: widget.size ?? 24,
            decoration: widget.boxDecoration ??
                BoxDecoration(
                  color: _isChecked ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(6),
                ),
            child: _isChecked ? Center(child: widget.check ?? Icon(Icons.check, color: Get.theme.primaryColor)) : null,
          ),
          if (widget.labelText != null) ...[
            const SizedBox(width: 8),
            Text(widget.labelText!, style: widget.textStyle ?? Get.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
