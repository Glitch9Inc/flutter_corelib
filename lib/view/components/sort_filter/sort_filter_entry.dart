import 'package:flutter_corelib/flutter_corelib.dart';

class SortFilterEntry extends ItemEntry {
  final InfoMessage? helpMessage;

  SortFilterEntry({
    required int index,
    required super.name,
    super.icon,
    this.helpMessage,
  }) : super(index: index);
}
