class DurationRange {
  final Duration min;
  final Duration max;

  const DurationRange({
    required this.min,
    required this.max,
  });

  Duration get random => Duration(milliseconds: (min.inMilliseconds + (max.inMilliseconds - min.inMilliseconds) * 0.5).toInt());
}
