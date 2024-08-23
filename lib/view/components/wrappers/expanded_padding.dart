import 'package:flutter/widgets.dart';

class ExpandedPadding extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget child;

  const ExpandedPadding({
    super.key,
    required this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
