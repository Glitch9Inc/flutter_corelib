import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_corelib/flutter_corelib.dart';

enum TimerType {
  limit,
  daily,
  weekly,
}

class TimerWidget extends StatefulWidget {
  final TimerType type;
  final TimeOfDay resetTime;
  final Weekday? resetDay;
  final double? width;
  final double? height;
  final String? text;
  final String? timerImagePath;
  final Color color;
  final Color? textColor;
  final EdgeInsets? margin;
  final EdgeInsets padding;
  final Alignment alignment;
  final double iconScale;

  const TimerWidget({
    super.key,
    required this.type,
    this.resetTime = const TimeOfDay(hour: 0, minute: 0),
    this.resetDay = Weekday.wednesday,
    this.width,
    this.height,
    this.color = Colors.black,
    this.textColor,
    this.text,
    this.margin,
    this.padding = const EdgeInsets.only(right: 8),
    this.timerImagePath,
    this.alignment = Alignment.centerLeft,
    this.iconScale = 1,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  String _remainingTime = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
    _updateRemainingTime();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

  DateTime _resolveResetDateTime() {
    final now = DateTime.now();
    DateTime resetDateTime;

    switch (widget.type) {
      case TimerType.limit:
        resetDateTime = now.add(const Duration(days: 1));
        break;
      case TimerType.daily:
        resetDateTime = DateTime(now.year, now.month, now.day, widget.resetTime.hour, widget.resetTime.minute);
        if (resetDateTime.isBefore(now)) {
          resetDateTime = resetDateTime.add(const Duration(days: 1));
        }
        break;
      case TimerType.weekly:
        resetDateTime = DateTime(now.year, now.month, now.day, widget.resetTime.hour, widget.resetTime.minute);
        while (resetDateTime.weekday != widget.resetDay!.index) {
          resetDateTime = resetDateTime.add(const Duration(days: 1));
        }
        if (resetDateTime.isBefore(now)) {
          resetDateTime = resetDateTime.add(const Duration(days: 7));
        }
        break;
    }

    return resetDateTime;
  }

  void _updateRemainingTime() {
    setState(() {
      final now = DateTime.now();
      final resetDateTime = _resolveResetDateTime();
      final remainingTime = resetDateTime.difference(now);

      final days = remainingTime.inDays;
      final hours = remainingTime.inHours % 24;
      final minutes = remainingTime.inMinutes % 60;
      final seconds = remainingTime.inSeconds % 60;

      if (widget.type == TimerType.daily) {
        _remainingTime =
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      } else {
        _remainingTime =
            '${days.toString().padLeft(2, '0')}:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _resolveTimerImage() {
    if (widget.timerImagePath != null) {
      return Image.asset(
        widget.timerImagePath!,
        width: 24,
        height: 24,
      );
    }
    return const Icon(
      Icons.timer,
      size: 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.alignment,
      children: [
        Container(
          margin: widget.margin,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(30),
          ),
          height: widget.height,
          width: widget.width,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.scale(scale: widget.iconScale, child: _resolveTimerImage()),
              if (widget.text != null) ...[
                Text(
                  widget.text!,
                  style: Get.textTheme.titleMedium!.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                _remainingTime,
                style: Get.textTheme.titleMedium!.copyWith(
                  color: widget.textColor ?? routinaGreenW300,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
