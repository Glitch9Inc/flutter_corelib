import 'package:flutter/material.dart';
import 'package:flutter_corelib/system/const/color_const.dart';

class UILoadingWidget extends StatefulWidget {
  final Widget loadingWidget;
  final Duration duration;
  final Color backgroundColor;

  const UILoadingWidget({
    super.key,
    this.duration = const Duration(milliseconds: 500),
    this.backgroundColor = transparentBlackW500,
    this.loadingWidget = const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(transparentWhiteW500),
    ),
  });

  @override
  State<UILoadingWidget> createState() => _UILoadingWidgetState();
}

class _UILoadingWidgetState extends State<UILoadingWidget> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.duration, () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Material(
            color: widget.backgroundColor,
            child: Center(
              child: widget.loadingWidget,
            ),
          )
        : const SizedBox();
  }
}
