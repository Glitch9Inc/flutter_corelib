import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

/// 개발중에만 사용하는 노트용 텍스트 위젯
class DevNote extends StatelessWidget {
  final String note;
  const DevNote(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.85,
      padding: const EdgeInsets.all(5),
      color: darkModePinkW700.withOpacity(0.3),
      child: Text(
        note,
        style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
      ),
    );
  }
}
