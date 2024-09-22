import 'package:flutter_corelib/flutter_corelib.dart';

class SortFilterController extends GetxController {
  final RxList<int> selectedFilters = <int>[].obs;
  final RxInt selectedSortType = 0.obs;
  final Rx<SortOrder> selectedSortOrder = SortOrder.decending.obs;

  SortFilterController({
    List<int>? initialFilters,
    int? initialSortType,
    SortOrder? initialSortOrder,
  }) {
    if (initialFilters != null) {
      selectedFilters.value = initialFilters;
    }
    if (initialSortType != null) {
      selectedSortType.value = initialSortType;
    }
    if (initialSortOrder != null) {
      selectedSortOrder.value = initialSortOrder;
    }
  }

  void setFilters(List<int> filters) {
    selectedFilters.value = filters;
  }

  void setSortType(int sortType) {
    selectedSortType.value = sortType;
  }

  void setSortOrder(SortOrder sortOrder) {
    selectedSortOrder.value = sortOrder;
  }
}
