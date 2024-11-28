import 'package:flutter_corelib/flutter_corelib.dart';

class SortFilterController<T extends SortableItem> extends GetxController {
  final List<T> items;
  final List<SortRule> sortTypes;
  final List<FilterRule> filters;

  final RxList<T> filteredItems = <T>[].obs;
  final RxList<String> appliedFilterKeys = <String>[].obs;
  final RxString appliedSortTypeKey = ''.obs;
  final Rx<SortOrder> appliedSortOrder = SortOrder.decending.obs;
  final RxString searchWord = ''.obs;

  late final List<String> initialFilters;
  late final String initialSortType;
  final SortOrder initialSortOrder;

  // 저장 여부
  final bool saveToPrefs;
  late final String filterPrefsKey;
  late final String sortTypePrefsKey;
  late final String sortOrderPrefsKey;

  SortFilterController({
    required this.items,
    required this.sortTypes,
    required this.filters,
    List<String>? initialFilters,
    String? initialSortType,
    this.initialSortOrder = SortOrder.decending,
    String? prefsKey,
    this.saveToPrefs = false,
  }) {
    if (initialFilters != null) {
      this.initialFilters = initialFilters;
    } else {
      this.initialFilters = filters.map((e) => e.key).toList();
    }

    if (initialSortType != null) {
      this.initialSortType = initialSortType;
    } else {
      this.initialSortType = sortTypes.first.key;
    }

    if (saveToPrefs) {
      if (prefsKey == null) {
        throw ArgumentError('prefsKey must be provided when saveToPrefs is true');
      }

      filterPrefsKey = '$prefsKey.filter';
      sortTypePrefsKey = '$prefsKey.sortType';
      sortOrderPrefsKey = '$prefsKey.sortOrder';
    }

    if (saveToPrefs && PlayerPrefs.hasKey(filterPrefsKey)) {
      appliedFilterKeys.value = PlayerPrefs.getStringList(filterPrefsKey);
    } else {
      if (initialFilters != null) {
        appliedFilterKeys.value = initialFilters;
      } else {
        appliedFilterKeys.value = filters.map((e) => e.key).toList();
      }
    }

    if (saveToPrefs && PlayerPrefs.hasKey(sortTypePrefsKey)) {
      appliedSortTypeKey.value = PlayerPrefs.getString(sortTypePrefsKey);
    } else {
      if (initialSortType != null) {
        appliedSortTypeKey.value = initialSortType;
      } else {
        appliedSortTypeKey.value = sortTypes.first.key;
      }
    }

    if (saveToPrefs && PlayerPrefs.hasKey(sortOrderPrefsKey)) {
      appliedSortOrder.value = SortOrder.values[PlayerPrefs.getInt(sortOrderPrefsKey)];
    } else {
      appliedSortOrder.value = initialSortOrder;
    }

    // _filterItems();
    // _sortItems();
  }

  void init() {
    _filterItems();
    _sortItems();
  }

  void setFilters(List<String> filters) {
    appliedFilterKeys.value = filters;
    if (saveToPrefs) {
      PlayerPrefs.setStringList(filterPrefsKey, filters);
    }
    _filterItems();
  }

  void clearFilters() {
    appliedFilterKeys.value = filters.map((e) => e.key).toList();
    if (saveToPrefs) {
      PlayerPrefs.remove(filterPrefsKey);
    }
    _filterItems();
  }

  void setSortType(String sortType) {
    appliedSortTypeKey.value = sortType;
    if (saveToPrefs) {
      PlayerPrefs.setString(sortTypePrefsKey, sortType);
    }
    _sortItems();
  }

  void setSortOrder(SortOrder sortOrder) {
    appliedSortOrder.value = sortOrder;
    if (saveToPrefs) {
      PlayerPrefs.setInt(sortOrderPrefsKey, sortOrder.index);
    }
    _sortItems();
  }

  void search(String word) {
    searchWord.value = word;
    _searchItems();
  }

  void clearSearch() {
    searchWord.value = '';
    _searchItems();
  }

  void resetItems() {
    appliedFilterKeys.value = initialFilters;
    appliedSortTypeKey.value = initialSortType;
    appliedSortOrder.value = initialSortOrder;
    searchWord.value = '';

    _filterItems();
    _sortItems();
  }

  void _filterItems() {
    filteredItems.clear();
    Debug.shout('Total items: ${items.length}');
    for (final item in items) {
      if (appliedFilterKeys.every((key) => item.filter(key))) {
        filteredItems.add(item);
      }
    }
  }

  void _sortItems() {
    final sortKey = appliedSortTypeKey.value;
    final sortOrder = appliedSortOrder.value;

    filteredItems.sort((a, b) {
      final String? aValue = a.sortData[sortKey];
      final String? bValue = b.sortData[sortKey];

      if (aValue == null || bValue == null) {
        return 0;
      }

      if (sortOrder == SortOrder.ascending) {
        return aValue.compareTo(bValue);
      } else {
        return bValue.compareTo(aValue);
      }
    });
  }

  void _searchItems() {
    final word = searchWord.value;
    if (word.isEmpty) return;
    filteredItems.removeWhere((item) => !item.search(word));
  }
}
