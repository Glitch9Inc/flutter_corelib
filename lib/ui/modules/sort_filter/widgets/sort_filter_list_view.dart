import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';
import 'sort_filter_checkbox.dart';

enum SortFilterListViewType {
  filter,
  sortType,
}

class SortFilterListView extends StatefulWidget {
  final SortFilterController controller;
  final String title;
  final int crossAxisCount;
  final SortFilterListViewType listViewType;

  const SortFilterListView({
    super.key,
    required this.controller,
    required this.title,
    required this.crossAxisCount,
    required this.listViewType,
  });

  @override
  State<SortFilterListView> createState() => _SortFilterListViewState();
}

class _SortFilterListViewState extends State<SortFilterListView> {
  bool _isSelected(RuleBase entry) {
    if (widget.listViewType == SortFilterListViewType.filter) {
      return widget.controller.appliedFilterKeys.contains(entry.key);
    } else {
      return widget.controller.appliedSortTypeKey.value == entry.key;
    }
  }

  void _onChanged(RuleBase entry, bool? value) {
    if (value == null) return;

    if (widget.listViewType == SortFilterListViewType.filter) {
      if (value) {
        widget.controller.appliedFilterKeys.add(entry.key);
      } else {
        widget.controller.appliedFilterKeys.remove(entry.key);
      }
    } else {
      widget.controller.appliedSortTypeKey.value = entry.key;
    }
  }

  double _calculateChildAspectRatio() {
    return 6.8 / widget.crossAxisCount;
  }

  Widget _buildGridView() {
    final entries = widget.listViewType == SortFilterListViewType.filter ? widget.controller.filters : widget.controller.sortTypes;

    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      shrinkWrap: true, // Makes the GridView as small as possible
      crossAxisCount: widget.crossAxisCount,
      childAspectRatio: _calculateChildAspectRatio(), // Adjust this to make items more compact vertically
      children: entries.map((entry) {
        return Center(
          // Center the content of each grid cell
          child: IntrinsicHeight(
              // Ensures that the child takes up only the necessary vertical space
              child: Obx(
            () => SortFilterCheckbox(
              rule: entry,
              isSelected: _isSelected(entry),
              onChanged: (bool? value) {
                _onChanged(entry, value);
              },
            ),
          )),
        );
      }).toList(),
    );
  }

  Widget _filterButtons() {
    final entries = widget.listViewType == SortFilterListViewType.filter ? widget.controller.filters : widget.controller.sortTypes;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // deselect all button
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.controller.appliedFilterKeys.clear();
            });
          },
          child: Text('Deselect all', style: Get.textTheme.bodyMedium, textAlign: TextAlign.center),
        ),

        const SizedBox(width: 20),

        // select all button
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.controller.appliedFilterKeys.clear();
              widget.controller.appliedFilterKeys.addAll(entries.map((e) => e.key));
            });
          },
          child: Text('Select all', style: Get.textTheme.bodyMedium, textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _button() {
    return EasyButton(
      width: 140,
      onPressed: () {
        Get.back();
      },
      text: 'Apply',
      //child: Text('Apply', style: Get.textTheme.bodyMedium, textAlign: TextAlign.center),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupBase(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.title, style: Get.textTheme.headlineSmall),
          const SizedBox(height: 10),
          _buildGridView(),
          const SizedBox(height: 20),
          if (widget.listViewType == SortFilterListViewType.filter) ...[
            _filterButtons(),
            const SizedBox(height: 10),
          ],
          _button(),
        ],
      ),
    );
  }
}
