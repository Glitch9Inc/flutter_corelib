import 'package:flutter/material.dart';

enum SortOrder {
  decending,
  ascending,
}

extension SortFilterOrderExtension on SortOrder {
  String get name {
    switch (this) {
      case SortOrder.decending:
        return 'Descending';
      case SortOrder.ascending:
        return 'Ascending';
    }
  }

  SortOrder get opposite {
    switch (this) {
      case SortOrder.decending:
        return SortOrder.ascending;
      case SortOrder.ascending:
        return SortOrder.decending;
    }
  }

  IconData get icon {
    switch (this) {
      case SortOrder.decending:
        return Icons.arrow_downward;
      case SortOrder.ascending:
        return Icons.arrow_upward;
    }
  }
}
