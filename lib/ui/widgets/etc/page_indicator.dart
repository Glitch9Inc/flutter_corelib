import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class PageIndicator extends StatefulWidget {
  final int itemCount;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double size;
  final double focusSize;
  final double space;
  final BoxDecoration? decoration;
  final List<Dot>? customDots;
  final EdgeInsetsGeometry padding;
  final Function(int)? onIndexChanged;

  const PageIndicator(
      {super.key,
      required this.itemCount,
      required this.currentIndex,
      this.decoration,
      this.size = 10,
      this.focusSize = 10,
      this.space = 5,
      this.padding = const EdgeInsets.all(15),
      this.activeColor = Colors.white,
      this.inactiveColor = Colors.grey,
      this.customDots,
      this.onIndexChanged});

  @override
  State<StatefulWidget> createState() => PageIndicatorState();
}

class PageIndicatorState extends State<PageIndicator> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(PageIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      currentIndex = widget.currentIndex;
    }
  }

  void updatePage(int index) {
    if (mounted) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  AnimatedContainer _buildDotContainer(int index) {
    bool focus = index == currentIndex;
    double size = focus ? widget.focusSize : widget.size;
    double iconSize = size * 0.7;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: size,
      height: size,
      margin: EdgeInsets.symmetric(horizontal: widget.space),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: focus ? (widget.customDots != null ? widget.customDots![index].color : widget.activeColor) : widget.inactiveColor,
      ),
      child: widget.customDots != null && widget.customDots![index].icon != null
          ? Icon(
              widget.customDots![index].icon,
              size: iconSize,
              //color: focus ? widget.activeColor : widget.inactiveColor,
            )
          : null,
    );
  }

  Widget _buildDot(int index) {
    if (widget.onIndexChanged != null) {
      return GestureDetector(
        onTap: () {
          widget.onIndexChanged!(index);
          updatePage(index);
        },
        child: _buildDotContainer(index),
      );
    } else {
      return _buildDotContainer(index);
    }
  }

  Row _buildRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.itemCount,
        _buildDot,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double paddingLongerSide = widget.padding.horizontal > widget.padding.vertical ? widget.padding.horizontal : widget.padding.vertical;
    double fixedHeight = widget.focusSize + paddingLongerSide;

    if (widget.decoration != null) {
      return Container(
        height: fixedHeight,
        padding: widget.padding,
        decoration: widget.decoration,
        child: _buildRow(),
      );
    } else {
      return _buildRow();
    }
  }
}
