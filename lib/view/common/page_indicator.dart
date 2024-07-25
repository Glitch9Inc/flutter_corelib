import 'package:flutter/material.dart';

class PageIndicator extends StatefulWidget {
  final int count;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double size;
  final double space;
  final BoxDecoration? decoration;
  final Function(int)? onIndexChanged;

  const PageIndicator(
      {Key? key,
      required this.count,
      required this.currentIndex,
      this.decoration,
      this.size = 10,
      this.space = 5,
      this.activeColor = Colors.white,
      this.inactiveColor = Colors.grey,
      this.onIndexChanged})
      : super(key: key);

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

  void updatePage(int index) {
    if (mounted) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  Container _buildDotContainer(int index) {
    return Container(
        width: widget.size,
        height: widget.size,
        margin: EdgeInsets.symmetric(horizontal: widget.space),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              index == currentIndex ? widget.activeColor : widget.inactiveColor,
        ));
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
        widget.count,
        _buildDot,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.decoration != null) {
      return Container(
        padding: const EdgeInsets.all(15),
        decoration: widget.decoration,
        child: _buildRow(),
      );
    } else {
      return _buildRow();
    }
  }
}
