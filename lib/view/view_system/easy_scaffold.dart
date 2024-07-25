import 'package:flutter/material.dart';

class EasyScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? background;
  final Color? backgroundColor;
  final bool canPop;

  const EasyScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.background,
    this.backgroundColor,
    this.canPop = true,
  });

  Widget _buildScaffold() {
    if (canPop) {
      return Scaffold(
        drawer: drawer,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        backgroundColor: backgroundColor,
        body: body,
      );
    } else {
      return PopScope(
        canPop: false,
        child: Scaffold(
          drawer: drawer,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
          backgroundColor: backgroundColor,
          body: body,
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
          SafeArea(
            child: _buildScaffold(),
          ),
        ],
      );
    } else {
      return SafeArea(
        child: _buildScaffold(),
      );
    }
  }
}
