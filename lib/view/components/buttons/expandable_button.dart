import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

class ExpandableButton extends StatefulWidget {
  const ExpandableButton({
    super.key,
    required this.color,
    this.padding,
    required this.buttons,
    required this.isLoading,
  });
  final EdgeInsets? padding;
  final Color color;
  final bool isLoading;
  final List<ButtonEntry> buttons;

  @override
  State<ExpandableButton> createState() => ExpandableButtonState();
}

class ExpandableButtonState extends State<ExpandableButton>
    with SingleTickerProviderStateMixin {
  static const int _durationInMillis = 300;
  static const double _size = 44.0;
  static const IconData _defaultIconData = Icons.question_mark;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _reverseScaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _durationInMillis),
      vsync: this,
    );

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _reverseScaleAnimation = ReverseAnimation(_scaleAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void collapse() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
        _controller.reverse();
      });
    }
  }

  void _toggle() {
    setState(() {
      if (!_isExpanded) {
        _isExpanded = true;
        _controller.forward();
      } else {
        _isExpanded = false;
        _controller.reverse();
      }
    });
  }

  Widget _createMainButton(IconData icon, Function() onPressed) {
    Color fillColor = widget.color.semiTransparent;
    Color borderColor = fillColor.light;
    double widthIncludingPadding =
        _size + (widget.padding?.left ?? 0) + (widget.padding?.right ?? 0);
    return RawMaterialButton(
      onPressed: onPressed,
      fillColor: fillColor,
      shape: CircleBorder(
          side: BorderSide(color: borderColor, width: widthIncludingPadding)),
      constraints: const BoxConstraints.tightFor(
        width: _size, // Custom width
        height: _size, // Custom height
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _createTransformedButton(
      int index, IconData icon, VoidCallback onPressed) {
    double left = index * _size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: left - 5,
          top: 3,
          height: _size,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
          ),
        );
      },
    );
  }

  Widget _createInnerButtons(double currentWidth) {
    return SizedBox(
      height: _size,
      width: currentWidth, // 최대 확장 크기 지정
      child: Stack(
        children: <Widget>[
          ...widget.buttons.map((e) => _createTransformedButton(
              e.index ?? 0, e.iconData ?? _defaultIconData, e.onTap)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var multiplier = _isExpanded ? 3 : 1;
    var target = _size * multiplier;
    var widthAnimation = Tween<double>(begin: _size, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double translateX = widthAnimation.value - target; // 너비에 따라 이동할 거리 계산
        return Transform(
          transform: Matrix4.identity()..translate(translateX, 0.0),
          alignment: Alignment.bottomLeft, // 변환의 기준점을 왼쪽으로 설정
          child: Stack(children: [
            ScaleTransition(
              scale: _reverseScaleAnimation,
              child: _createMainButton(Icons.add, _toggle),
            ),
            ScaleTransition(
              scale: _scaleAnimation,
              child: _createInnerButtons(widthAnimation.value),
            ),
          ]),
        );
      },
    );
  }
}
