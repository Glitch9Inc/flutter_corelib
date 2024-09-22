import 'package:flutter/material.dart';

class EasyScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? background;
  final List<Widget>? overlays;
  final Color backgroundColor;
  final double? customBottomNavigationBarHeight;
  final bool canPop;

  const EasyScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.background,
    this.overlays,
    this.backgroundColor = Colors.transparent,
    this.canPop = true,
    this.customBottomNavigationBarHeight,
  });

  Widget? _resolveBottomNavigationBarInsideScaffold() {
    if (customBottomNavigationBarHeight != null) {
      return null;
    } else {
      return bottomNavigationBar;
    }
  }

  Widget? _resolveBody() {
    if ((bottomNavigationBar != null && customBottomNavigationBarHeight != null) ||
        (overlays != null && overlays!.isNotEmpty)) {
      return Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: customBottomNavigationBarHeight!),
            child: body,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: bottomNavigationBar,
          ),
          if (overlays != null && overlays!.isNotEmpty) ...overlays!,
        ],
      );
    } else {
      return body;
    }
  }

  Widget _buildScaffold() {
    if (canPop) {
      return Scaffold(
        drawer: drawer,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: _resolveBottomNavigationBarInsideScaffold(),
        backgroundColor: backgroundColor,
        body: _resolveBody(),
      );
    } else {
      return PopScope(
        canPop: false,
        child: Scaffold(
          drawer: drawer,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: _resolveBottomNavigationBarInsideScaffold(),
          backgroundColor: backgroundColor,
          body: _resolveBody(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (background != null) {
      return Stack(
        children: [
          background!,
          _buildScaffold(),
        ],
      );
    } else {
      return _buildScaffold();
    }
  }
}
