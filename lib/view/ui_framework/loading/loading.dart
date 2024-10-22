import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

mixin LoadingWidgetMixin on Widget {
  LoadingControllerBase get controller;
}

abstract class Loading {
  static LoadingControllerBase? _currentController;
  static bool _loadingStarted = false;

  static void show(
    LoadingWidgetMixin loadingWidget, {
    Color? backgroundColor,
  }) {
    _loadingStarted = true;
    _currentController = loadingWidget.controller;

    Get.dialog(
      loadingWidget,
      barrierDismissible: false,
      barrierColor: backgroundColor,
    );
  }

  static void internalStart(LoadingControllerBase controller) {
    _loadingStarted = true;
    _currentController = controller;
  }

  static void next() {
    if (!_loadingStarted) return;
    if (_currentController == null) {
      throw Exception('Loading controller is null');
    }
    if (_currentController is ManualLoadingController) {
      (_currentController as ManualLoadingController).next();
    }
  }

  static void complete({bool force = false}) {
    if (_currentController == null) {
      throw Exception('Loading controller is null');
    }
    if (!force && _currentController!.isCompleted.value) {
      return;
    }
    _currentController!.complete();
    hide();
  }

  static void hide({bool force = false}) {
    if (_currentController == null) {
      throw Exception('Loading controller is null');
    }
    if (!force && _currentController!.isCompleted.value) {
      return;
    }
    Get.back();
    _currentController = null;
    _loadingStarted = false;
  }
}
