import 'package:flutter/material.dart';

class EasyScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? background;
  final List<Widget>? overlays;
  final Color backgroundColor;
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
  });

  Widget? _resolveBody() {
    if (bottomNavigationBar != null || (overlays != null && overlays!.isNotEmpty)) {
      return Stack(
        children: [
          body,
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              child: bottomNavigationBar,
            ),
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

  @override
  Widget build(BuildContext context) {
    if (background != null) {
      return Stack(
        children: [
          Positioned.fill(child: background!),
          _buildScaffold(),
        ],
      );
    } else {
      return _buildScaffold();
    }
  }
}
