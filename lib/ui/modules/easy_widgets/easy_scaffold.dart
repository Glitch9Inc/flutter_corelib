import 'package:flutter/material.dart';

class EasyScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? floatingCenterButton;
  final double floatingCenterButtonPadding;
  final Widget? bottomNavigationBar;
  final double bottomNavigationBarHeight;
  final Widget? drawer;
  final Widget? background;
  final Widget? appBar;
  final Color backgroundColor;
  final bool canPop;

  const EasyScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.floatingCenterButton,
    this.floatingCenterButtonPadding = 24,
    this.bottomNavigationBar,
    this.bottomNavigationBarHeight = 80,
    this.drawer,
    this.background,
    this.appBar,
    this.backgroundColor = Colors.transparent,
    this.canPop = true,
  }) // [floatingCenterButton] and [bottomNavigationBar] cannot be used together
  : assert(floatingCenterButton == null || bottomNavigationBar == null);

  Widget? _resolveBody() {
    if (background != null || bottomNavigationBar != null || floatingCenterButton != null || appBar != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          if (background != null) Positioned.fill(child: background!),
          body,
          if (bottomNavigationBar != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: bottomNavigationBarHeight,
              child: bottomNavigationBar!,
            ),
          if (floatingCenterButton != null)
            Positioned(
              bottom: floatingCenterButtonPadding,
              left: 0,
              right: 0,
              child: floatingCenterButton!,
            ),
          if (appBar != null) appBar!,
        ],
      );
    } else {
      return body;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (canPop) {
      return Scaffold(
        drawer: drawer,
        floatingActionButton: floatingActionButton,
        backgroundColor: backgroundColor,
        body: _resolveBody(),
      );
    } else {
      return PopScope(
        canPop: false,
        child: Scaffold(
          drawer: drawer,
          floatingActionButton: floatingActionButton,
          backgroundColor: backgroundColor,
          body: _resolveBody(),
        ),
      );
    }
  }
}
