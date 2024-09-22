import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class InfoButton extends StatelessWidget {
  final double size;
  final InfoMessage infoMessage;

  const InfoButton(this.infoMessage, {super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(alignment: Alignment.center, children: [
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: routinaTealW800,
            shape: BoxShape.circle,
          ),
        ),
        Center(
            child: Icon(
          Icons.question_mark_sharp,
          color: Colors.white,
          size: size - 5,
        )),
      ]),
      onTap: () {
        MyDialog.showOverlay(
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 300,
              constraints: const BoxConstraints(minHeight: 300),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    infoMessage.title,
                    style: Get.theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    infoMessage.message,
                    style: Get.theme.textTheme.bodyLarge,
                  ),
                ],
              )),
        );
      },
    );
  }
}
