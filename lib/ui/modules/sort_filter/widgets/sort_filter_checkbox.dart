import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class SortFilterCheckbox extends StatelessWidget {
  final RuleBase rule;
  final bool isSelected;
  final void Function(bool?) onChanged;

  const SortFilterCheckbox({
    super.key,
    required this.rule,
    required this.isSelected,
    required this.onChanged,
  });

  void _onClick() {
    if (rule.helpMessage == null) {
      return;
    }
    Get.dialog(AlertDialog(
      title: Text(rule.helpMessage!.title),
      content: Text(rule.helpMessage!.message),
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
      activeColor: darkModeGreenW500,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      value: isSelected,
      onChanged: (bool? value) {
        onChanged(value);
      },
      title: Row(
        children: [
          if (rule.icon != null) ...[
            SizedBox(
              width: 24,
              height: 24,
              child: Stack(clipBehavior: Clip.none, children: [
                rule.icon!,
                //if (entry.helpMessage != null) _badgeIcon(),
              ]),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              rule.name,
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
