import 'package:flutter/material.dart';

enum MessageType {
  info,
  warning,
  error,
  success,
  criticalError,
}

/// UnityEditor 인스펙터 스타일의 helpbox 위젯
class HelpBox extends StatelessWidget {
  final String text;
  final MessageType? type;
  final Decoration? decoration;

  const HelpBox(
    this.text, {
    super.key,
    this.type,
    this.decoration,
  });

  IconData _resolveIcon() {
    switch (type) {
      case MessageType.info:
        return Icons.info;
      case MessageType.warning:
        return Icons.warning;
      case MessageType.error:
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  Decoration _resolveDecoration() {
    if (decoration != null) {
      return decoration!;
    }
    return BoxDecoration(
      color: type == MessageType.error
          ? Colors.red.withOpacity(.1)
          : type == MessageType.warning
              ? Colors.yellow.withOpacity(.1)
              : Colors.blue.withOpacity(.1),
      border: Border.all(
        color: type == MessageType.error
            ? Colors.red
            : type == MessageType.warning
                ? Colors.yellow
                : Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: _resolveDecoration(),
      child: Row(
        children: [
          Icon(
            _resolveIcon(),
            color: type == MessageType.error
                ? Colors.red
                : type == MessageType.warning
                    ? Colors.yellow
                    : Colors.blue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: type == MessageType.error
                    ? Colors.red
                    : type == MessageType.warning
                        ? Colors.yellow
                        : Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
