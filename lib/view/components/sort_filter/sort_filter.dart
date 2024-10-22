import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:flutter_corelib/view/components/sort_filter/sort_filter_popup_content.dart';

export 'sort_filter_entry.dart';
export 'sort_filter_controller.dart';
export 'sort_filter_decoration.dart';
export 'sort_order.dart';

class SortFilter extends StatefulWidget {
  final SortFilterDecoration decoration;
  final SortFilterController controller;
  final List<SortFilterEntry> filters;
  final List<SortFilterEntry> sortTypes;

  // grid item options
  final double listItemHeight;
  final int filterCrossAxisCount;
  final int sortTypeCrossAxisCount;
  final String? filterTitle;
  final String? sortTypeTitle;

  const SortFilter({
    super.key,
    required this.controller,
    required this.filters,
    required this.sortTypes,
    this.decoration = const SortFilterDecoration(),
    this.listItemHeight = 30,
    this.filterCrossAxisCount = 2,
    this.sortTypeCrossAxisCount = 1,
    this.filterTitle,
    this.sortTypeTitle,
  });

  @override
  State<SortFilter> createState() => _SortFilterState();
}

class _SortFilterState extends State<SortFilter> {
  late final TextStyle _textStyle;
  late final double _sortTypeWidth;
  late final double _sortOrderWidth;
  late final double _filterWidth;
  late final Widget _accendingArrow;
  late final Widget _decendingArrow;

  @override
  void initState() {
    super.initState();
    _textStyle = widget.decoration.textStyle ?? Get.textTheme.bodyMedium ?? const TextStyle();
    _sortTypeWidth = widget.decoration.sortTypeWidth ?? widget.listItemHeight * 2.25;
    _sortOrderWidth = widget.decoration.sortOrderWidth ?? widget.listItemHeight;
    _filterWidth = widget.decoration.filterWidth ?? widget.listItemHeight * 2.25;
    _accendingArrow = widget.decoration.ascendingArrow ?? const Icon(Icons.arrow_upward);
    _decendingArrow = widget.decoration.decendingArrow ?? const Icon(Icons.arrow_downward);
  }

  Widget _container(double width, Color color, Widget child, double borderRadius, BorderDirection borderDirection) {
    return EasyContainer(
      //alignment: Alignment.center,
      height: widget.listItemHeight - 5,
      thickness: 1,
      width: width,
      // decoration: BoxDecoration(
      //   color: color,
      //   borderRadius: borderDirection.resolveBorderRadius(borderRadius),
      //   border: borderDirection.resolveBorder(widget.decoration.borderColor, 2, true),
      // ),

      color: color,
      child: child,
    );
  }

  Widget _text(String text, Color color) {
    return StrokeText(
      text,
      style: _textStyle,
      strokeStyle: StrokeStyle(
        type: StrokeType.shadow,
        color: color,
      ),
    );
  }

  Widget _sortType() {
    return InkWell(
      onTap: () async {
        await Get.dialog<SortFilterEntry>(
          PopupMaterial(
            padding: const EdgeInsets.all(20),
            child: SortFilterPopupContent(
              type: SortFilterType.sortType,
              controller: widget.controller,
              title: widget.sortTypeTitle ?? 'Sort by',
              crossAxisCount: widget.sortTypeCrossAxisCount,
              entries: widget.sortTypes,
            ),
          ),
        );
      },
      child: _container(
        _sortTypeWidth,
        widget.decoration.sortTypeColor,
        _text(widget.sortTypeTitle ?? 'Sort by', widget.decoration.sortTypeColor),
        widget.decoration.borderRadius,
        BorderDirection.right,
      ),
    );
  }

  Widget _sortOrder() {
    final selectedSortOrder = widget.controller.selectedSortOrder.value;

    return InkWell(
      onTap: () {
        setState(() {
          final newOrder = selectedSortOrder == SortOrder.ascending ? SortOrder.decending : SortOrder.ascending;
          widget.controller.setSortOrder(newOrder);
        });
      },
      child: _container(
        _sortOrderWidth,
        widget.decoration.sortOrderColor,
        selectedSortOrder == SortOrder.ascending ? _accendingArrow : _decendingArrow,
        0,
        BorderDirection.none,
      ),
    );
  }

  Widget _filter() {
    return InkWell(
      onTap: () async {
        await Get.dialog<List<SortFilterEntry>>(
          PopupMaterial(
              padding: const EdgeInsets.all(20),
              child: SortFilterPopupContent(
                type: SortFilterType.filter,
                controller: widget.controller,
                title: widget.filterTitle ?? 'Filter',
                crossAxisCount: widget.filterCrossAxisCount,
                entries: widget.filters,
              )),
        );
      },
      child: _container(
        _filterWidth,
        widget.decoration.filterColor,
        _text(widget.filterTitle ?? 'Filter', widget.decoration.filterColor),
        widget.decoration.borderRadius,
        BorderDirection.left,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _filter(),
        _sortOrder(),
        _sortType(),
      ],
    );
  }
}
