import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class SortTypePopupContent extends StatefulWidget {
  final List<SortFilterEntry> sortTypes;
  final SortFilterEntry selectedSortType;
  final void Function(SortFilterEntry) onSortTypeChanged;

  const SortTypePopupContent({
    super.key,
    required this.sortTypes,
    required this.selectedSortType,
    required this.onSortTypeChanged,
  });

  @override
  State<SortTypePopupContent> createState() => _SortTypePopupContentState();
}

class _SortTypePopupContentState extends State<SortTypePopupContent> {
  late SortFilterEntry _selectedSortType;

  @override
  void initState() {
    super.initState();
    _selectedSortType = widget.selectedSortType;
  }

  Widget _buildContent() {
    return Column(
      children: [
        for (SortFilterEntry sortType in widget.sortTypes)
          ListTile(
            onTap: () {
              setState(() {
                _selectedSortType = sortType;
              });
            },
            title: Text(sortType.name),
            leading: sortType.icon,
            trailing: _selectedSortType == sortType ? const Icon(Icons.check) : null,
          ),
        ElevatedButton(
          onPressed: () {
            widget.onSortTypeChanged(_selectedSortType);
            Get.back();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }
}
