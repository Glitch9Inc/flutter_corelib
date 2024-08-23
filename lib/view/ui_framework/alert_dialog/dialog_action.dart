import 'dart:ui';

class DialogAction {
  final String text;
  final VoidCallback onPressed;

  DialogAction({
    required this.text,
    required this.onPressed,
  });
}
