import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';
import 'sort_filter_checkbox.dart';

enum SortFilterType {
  filter,
  sortType,
}

class SortFilterPopupContent extends StatefulWidget {
  final SortFilterController controller;
  final String title;
  final int crossAxisCount;
  final List<SortFilterEntry> entries;
  final SortFilterType type;

  const SortFilterPopupContent({
    super.key,
    required this.controller,
    required this.title,
    required this.crossAxisCount,
    required this.entries,
    required this.type,
  });

  @override
  State<SortFilterPopupContent> createState() => _SortFilterPopupContentState();
}

class _SortFilterPopupContentState extends State<SortFilterPopupContent> {
  SortFilterType get type => widget.type;

  bool _isSelected(SortFilterEntry entry) {
    if (type == SortFilterType.filter) {
      return widget.controller.selectedFilters.contains(entry.index);
    } else {
      return widget.controller.selectedSortType.value == entry.index;
    }
  }

  void _onChanged(SortFilterEntry entry, bool? value) {
    if (value == null) return;

    if (type == SortFilterType.filter) {
      if (value) {
        widget.controller.selectedFilters.add(entry.index);
      } else {
        widget.controller.selectedFilters.remove(entry.index);
      }
    } else {
      widget.controller.selectedSortType.value = entry.index;
    }
  }

  double _calculateChildAspectRatio() {
    return 6.8 / widget.crossAxisCount;
  }

  Widget _gridView() {
    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      shrinkWrap: true, // Makes the GridView as small as possible
      crossAxisCount: widget.crossAxisCount,
      childAspectRatio: _calculateChildAspectRatio(), // Adjust this to make items more compact vertically
      children: widget.entries.map((entry) {
        return Center(
          // Center the content of each grid cell
          child: IntrinsicHeight(
              // Ensures that the child takes up only the necessary vertical space
              child: Obx(
            () => SortFilterCheckbox(
              entry: entry,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // deselect all button
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.controller.selectedFilters.clear();
            });
          },
          child: Text('Deselect all', style: Get.textTheme.bodyMedium, textAlign: TextAlign.center),
        ),

        const SizedBox(width: 20),

        // select all button
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.controller.selectedFilters.clear();
              widget.controller.selectedFilters.addAll(widget.entries.map((e) => e.index));
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
    return PopupContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.title, style: Get.textTheme.headlineSmall),
          const SizedBox(height: 10),
          _gridView(),
          const SizedBox(height: 20),
          if (type == SortFilterType.filter) ...[
            _filterButtons(),
            const SizedBox(height: 10),
          ],
          _button(),
        ],
      ),
    );
  }
}
