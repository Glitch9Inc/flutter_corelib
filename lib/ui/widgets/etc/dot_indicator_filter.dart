import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

/// T는 어떤 타입의 값으로 필터링을 할 것인지를 나타낸다.
class DotIndicatorFilter<T> extends StatefulWidget {
  final Color inactiveColor;
  final double inactiveSize;
  final double activeSize;
  final double space;
  final BoxDecoration? decoration; // container decoration
  final List<FilterDot<T>> dots;
  final EdgeInsetsGeometry padding;
  final List<int>? dividers; // Dot 사이에 구분선. 예를들어, [1]이면 0번째와 1번째 점 사이에 구분선이 생긴다.
  final List<T>? initialValues; // 초기 필터링 값
  final double? maxWidth;
  final OverflowBehavior overflowBehavior;
  final void Function(List<T>)? onFiltered;
  final void Function(T, bool)? onFilterChanged;

  const DotIndicatorFilter({
    super.key,
    required this.dots,
    this.onFiltered,
    this.onFilterChanged,
    this.dividers,
    this.decoration,
    this.initialValues = const [],
    this.inactiveSize = 10,
    this.activeSize = 10,
    this.space = 5,
    this.padding = const EdgeInsets.all(15),
    this.inactiveColor = Colors.grey,
    this.maxWidth,
    this.overflowBehavior = OverflowBehavior.scroll,
  });

  @override
  DotIndicatorFilterState<T> createState() => DotIndicatorFilterState<T>();
}

class DotIndicatorFilterState<T> extends State<DotIndicatorFilter<T>> {
  late List<T> currentValues;
  late Color inactiveIconColor;

  @override
  void initState() {
    super.initState();
    currentValues = List.from(widget.initialValues!);
    inactiveIconColor = widget.inactiveColor.brighten(0.1);
  }

  T _getValue(int index) {
    return widget.dots[index].value;
  }

  void _addToFilter(int index) {
    T value = _getValue(index);
    if (!currentValues.contains(value)) {
      currentValues.add(value);
    }
  }

  void _removeFromFilter(int index) {
    // 1개밖에 없는 필터는 제거할 수 없다.
    if (currentValues.length == 1) {
      return;
    }

    T value = _getValue(index);
    if (currentValues.contains(value)) {
      currentValues.remove(value);
    }
  }

  void _toggleFilter(int index) {
    if (currentValues.contains(_getValue(index))) {
      _removeFromFilter(index);
    } else {
      _addToFilter(index);
    }
  }

  AnimatedContainer _buildDotContainer(int index) {
    bool active = currentValues.contains(_getValue(index));
    double size = active ? widget.activeSize : widget.inactiveSize;
    double iconSize = size * 0.7;
    IconData icon = widget.dots[index].icon ?? Icons.question_mark;
    Border? border = active ? Border.all(color: Get.theme.colorScheme.outline, width: 2) : null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: size,
      height: size,
      margin: EdgeInsets.symmetric(horizontal: widget.space),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? widget.dots[index].color : widget.inactiveColor,
        border: border,
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: active ? Colors.white : inactiveIconColor,
      ),
    );
  }

  Widget _buildDot(int index) {
    bool hasDivider = widget.dividers != null && widget.dividers!.contains(index);

    if (hasDivider) {
      return Row(
        children: [
          const VerticalDivider(
            color: Colors.grey,
            thickness: 1,
          ),
          _buildDotButton(index),
        ],
      );
    } else {
      return _buildDotButton(index);
    }
  }

  GestureDetector _buildDotButton(int index) {
    return GestureDetector(
      onTap: () {
        if (mounted) {
          setState(() {
            _toggleFilter(index);
            widget.onFiltered?.call(currentValues);
            widget.onFilterChanged?.call(_getValue(index), currentValues.contains(_getValue(index)));
          });
        }
      },
      child: _buildDotContainer(index),
    );
  }

  Widget _buildRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.dots.length,
          _buildDot,
        ));
  }

  Widget _buildWrap() {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      //spacing: widget.space,
      children: List.generate(
        widget.dots.length,
        _buildDot,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double paddingLongerSide =
        widget.padding.horizontal > widget.padding.vertical ? widget.padding.horizontal : widget.padding.vertical;
    double fixedHeight = widget.activeSize + paddingLongerSide;
    Widget content;
    bool isScroll = false;

    switch (widget.overflowBehavior) {
      case OverflowBehavior.scroll:
        isScroll = true;
        EdgeInsetsGeometry padding = EdgeInsets.symmetric(horizontal: widget.padding.horizontal / 2, vertical: 0);
        content = HorizontalShaderMask(
            child: SingleChildScrollView(
          padding: padding,
          scrollDirection: Axis.horizontal,
          child: _buildRow(),
        ));
        break;
      case OverflowBehavior.wrap:
        content = _buildWrap();
        break;
    }

    if (widget.decoration != null) {
      EdgeInsetsGeometry padding = EdgeInsets.symmetric(
          horizontal: isScroll ? 0 : widget.padding.horizontal / 2, vertical: widget.padding.vertical / 2);
      return Container(
        height: fixedHeight,
        width: widget.maxWidth,
        padding: padding,
        decoration: widget.decoration,
        child: content,
      );
    } else {
      return content;
    }
  }
}
