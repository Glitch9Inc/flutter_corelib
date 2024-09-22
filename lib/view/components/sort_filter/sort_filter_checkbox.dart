import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class SortFilterCheckbox extends StatelessWidget {
  final SortFilterEntry entry;
  final bool isSelected;
  final void Function(bool?) onChanged;

  const SortFilterCheckbox({
    super.key,
    required this.entry,
    required this.isSelected,
    required this.onChanged,
  });

  void _onClick() {
    if (entry.helpMessage == null) {
      return;
    }
    Get.dialog(AlertDialog(
      title: Text(entry.helpMessage!.title),
      content: Text(entry.helpMessage!.message),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('OK'),
        ),
      ],
    ));
  }

  Widget _badgeIcon() {
    return Transform.translate(
      offset: const Offset(15, -15),
      child: const Icon(
        Icons.live_help,
        color: Colors.yellow,
        size: 15,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      activeColor: routinaGreenW500,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      value: isSelected,
      onChanged: (bool? value) {
        onChanged(value);
      },
      title: Row(
        children: [
          if (entry.icon != null) ...[
            SizedBox(
              width: 24,
              height: 24,
              child: Stack(clipBehavior: Clip.none, children: [
                entry.icon!,
                //if (entry.helpMessage != null) _badgeIcon(),
              ]),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              entry.name,
              style: Get.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
