import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class GNSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final double? width;
  final SliderThumb? thumb;
  final double thickness;
  final Color fillColor;
  final Color backgroundColor;
  final Function(double)? onChanged;

  const GNSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.thumb,
    this.width,
    this.thickness = 4.0,
    this.fillColor = const Color.fromARGB(255, 23, 165, 167),
    this.backgroundColor = const Color.fromARGB(255, 84, 84, 84),
  });

  @override
  State<GNSlider> createState() => _GNSliderState();
}

class _GNSliderState extends State<GNSlider> {
  late double _value;
  late SliderThumb _thumb;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _thumb = widget.thumb ?? SliderThumb.basic();
  }

  void _updateValue(Offset localPosition, double width) {
    double ratio = localPosition.dx / width;
    double newValue = widget.min + (ratio * (widget.max - widget.min));
    newValue = newValue.clamp(widget.min, widget.max); // 값 범위 제한
    setState(() {
      _value = newValue;
    });
    widget.onChanged?.call(newValue);
  }

  Widget _buildThumb(double sliderWidth) {
    var thumbPosition = (_value - widget.min) / (widget.max - widget.min) * sliderWidth;

    return Positioned(
      left: thumbPosition - _thumb.radius, // Thumb의 중앙에 위치시키기 위해 좌측으로 반경만큼 이동
      child: _thumb,
    );
  }

  @override
  Widget build(BuildContext context) {
    double sliderWidth = widget.width ?? MediaQuery.of(context).size.width;
    sliderWidth = sliderWidth.isFinite ? sliderWidth : MediaQuery.of(context).size.width;

    return GestureDetector(
      onPanUpdate: (details) {
        _updateValue(details.localPosition, sliderWidth);
      },
      onPanStart: (details) {
        _updateValue(details.localPosition, sliderWidth);
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: sliderWidth,
            child: CustomPaint(
              painter: _SliderPainter(
                thumbRadius: _thumb.radius,
                thickness: widget.thickness,
                borderRadius: _thumb.radius,
                value: _value,
                min: widget.min,
                max: widget.max,
                fillColor: widget.fillColor,
                backgroundColor: widget.backgroundColor,
              ),
              child: Container(), // 빈 컨테이너로 크기 지정
            ),
          ),
          _buildThumb(sliderWidth),
        ],
      ),
    );
  }
}

class _SliderPainter extends CustomPainter {
  final double thumbRadius;
  final double borderRadius;
  final double thickness;
  final double value;
  final double min;
  final double max;
  final Color fillColor;
  final Color backgroundColor;

  _SliderPainter({
    required this.thumbRadius,
    required this.thickness,
    required this.borderRadius,
    required this.value,
    required this.min,
    required this.max,
    required this.fillColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trackPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final Paint activeTrackPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    // 트랙 그리기
    final RRect trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height / 2 - thickness / 2, size.width, thickness),
      Radius.circular(borderRadius),
    );
    canvas.drawRRect(trackRect, trackPaint);

    // 활성 트랙 그리기
    final double activeTrackWidth = (value - min) / (max - min) * size.width;
    final RRect activeTrackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height / 2 - thickness / 2, activeTrackWidth, thickness),
      Radius.circular(borderRadius),
    );
    canvas.drawRRect(activeTrackRect, activeTrackPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 항상 새로 그리도록 설정
  }
}
