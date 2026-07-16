import 'package:flutter_corelib/prefs/flutter_prefs.dart';

class ItemIndex {
  final String id;
  final int index;

  const ItemIndex({
    required this.id,
    required this.index,
  });

  static String prefsKey(String id) => 'item_index_$id';

  factory ItemIndex.loadFromPrefs(String id) {
    final index = FlutterPrefs.getInt(prefsKey(id), defaultValue: -1);
    return ItemIndex(id: id, index: index);
  }

  factory ItemIndex.saveToPrefs(String id, int index) {
    FlutterPrefs.setInt(prefsKey(id), index);
    return ItemIndex(id: id, index: index);
  }

  ItemIndex copyWith({String? id, int? index}) {
    return ItemIndex(
      id: id ?? this.id,
      index: index ?? this.index,
    );
  }
}
