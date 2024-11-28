import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:flutter_corelib/ui/services/popup/views/overlay_base.dart';

enum PopupType {
  none,
  overlay,
  fullscreen,
}

enum ConfirmationType {
  confirmAndCancel,
  yesAndNo,
}

abstract class Popup {
  /// You can set the close button to be displayed in the popup dialog.
  static BasePopupCloseButton closeButton = const PopupCloseButton();
  static final _logger = Logger('Popup');

  // Sfx Callbacks
  static VoidCallback? sfxOnPopupShow;
  static VoidCallback? sfxOnPopupClose;
  static VoidCallback? sfxOnOverlayShow;
  static VoidCallback? sfxOnOverlayClose;
  static VoidCallback? sfxOnFullscreenShow;
  static VoidCallback? sfxOnFullscreenClose;

  // Message callbacks
  static VoidCallback? onInfoDialogShow;
  static VoidCallback? onSuccessDialogShow;
  static VoidCallback? onWarningDialogShow;
  static VoidCallback? onErrorDialogShow;

  // 1번쓰고 버리는 콜백
  static VoidCallback? onCloseSingleUse;

  static PopupType currentType = PopupType.none;
  static RxBool showCloseButton = true.obs;

  // Getters
  static double get dialogWidth => Get.width * 0.84;

  static Future<void> show(
    Widget popupWidget, {
    EdgeInsets screenPadding = const EdgeInsets.all(20),
    //VoidCallback? overrideOnShow,
  }) async {
    // if (overrideOnShow != null) {
    //   overrideOnShow();
    // } else {
    //   sfxOnPopupShow?.call();
    // }

    currentType = PopupType.none;

    // UI 변경을 다음 프레임까지 지연시키기 위해 좀 기다림
    await SchedulerBinding.instance.endOfFrame;

    await Get.dialog(
      PopupMaterial(
        padding: screenPadding,
        child: popupWidget,
      ),
    );
  }

  static Future<void> close({
    int count = 1,
    VoidCallback? overrideOnClose,
    bool ignoreOnClose = false,
  }) async {
    if (onCloseSingleUse != null) {
      onCloseSingleUse!();
      onCloseSingleUse = null;
    }
    // UI 변경을 다음 프레임까지 지연시키기 위해 좀 기다림
    await SchedulerBinding.instance.endOfFrame;

    if (count == 1) {
      Get.back();
    } else {
      Get.close(count);
    }

    if (!ignoreOnClose) {
      if (overrideOnClose != null) {
        overrideOnClose();
      } else {
        if (currentType == PopupType.none) {
          sfxOnPopupClose?.call();
        } else if (currentType == PopupType.overlay) {
          sfxOnOverlayClose?.call();
        } else if (currentType == PopupType.fullscreen) {
          sfxOnFullscreenClose?.call();
        }
      }
    }
  }

  static Future<void> infoDialog({
    required String title,
    required String message,
    VoidCallback? onClose,
    Widget? image,
    List<PopupAction>? actions,
  }) async {
    await messageDialog(
      title: title,
      message: message,
      messageType: MessageType.info,
      onClose: onClose,
      actions: actions,
      image: image,
      overrideOnShow: onInfoDialogShow,
    );
  }

  static Future<void> successDialog(
      {required String title, required String message, VoidCallback? onClose, Widget? image, List<PopupAction>? actions}) async {
    await messageDialog(
      title: title,
      message: message,
      messageType: MessageType.success,
      onClose: onClose,
      actions: actions,
      image: image,
      overrideOnShow: onSuccessDialogShow,
    );
  }

  static Future<void> warningDialog(
      {required String title, required String message, VoidCallback? onClose, Widget? image, List<PopupAction>? actions}) async {
    _logger.warning('Warning dialog: $title, $message');
    await messageDialog(
      title: title,
      message: message,
      messageType: MessageType.warning,
      onClose: onClose,
      actions: actions,
      image: image,
      overrideOnShow: onWarningDialogShow,
    );
  }

  static Future<void> errorDialog(
      {required String title, required String message, VoidCallback? onClose, Widget? image, List<PopupAction>? actions}) async {
    _logger.severe('Error dialog: $title, $message');
    await messageDialog(
      title: title,
      message: message,
      messageType: MessageType.error,
      onClose: onClose,
      actions: actions,
      image: image,
      overrideOnShow: onErrorDialogShow,
    );
  }

  static Future<void> criticalErrorDialog(
      {required String title, required String message, VoidCallback? onClose, Widget? image, List<PopupAction>? actions}) async {
    _logger.severe('Critical error dialog: $title, $message');
    await messageDialog(
      title: title,
      message: message,
      messageType: MessageType.criticalError,
      onClose: onClose,
      actions: actions,
      image: image,
      overrideOnShow: onErrorDialogShow,
    );
  }

  static Future<void> confirmationDialog({
    required String title,
    String? message,
    List<TextSpan>? messageSpans,
    required VoidCallback onPositive,
    VoidCallback? onNegative,
    Widget? image,
    ConfirmationType confirmationType = ConfirmationType.confirmAndCancel,
    MaterialColor? negativeColor, // = UIColor.red,
    MaterialColor? positiveColor, // = UIColor.green,
    int? buttonsInRow,
    bool reverseButtons = false,
    String? positiveButtonLabel,
    String? negativeButtonLabel,
  }) async {
    final positiveText = positiveButtonLabel ?? (confirmationType == ConfirmationType.confirmAndCancel ? 'Confirm' : 'Yes');
    final negativeText = negativeButtonLabel ?? (confirmationType == ConfirmationType.confirmAndCancel ? 'Cancel' : 'No');
    final posColor = positiveColor ?? WidgetColor.green;
    final negColor = negativeColor ?? WidgetColor.red;

    await messageDialog(
      title: title,
      message: message,
      messageSpans: messageSpans,
      messageType: MessageType.info,
      actions: [
        PopupAction(
          text: negativeText,
          color: negColor,
          onPressed: onNegative ?? () => Popup.close(),
        ),
        PopupAction(
          text: positiveText,
          color: posColor,
          onPressed: onPositive,
        ),
      ],
      image: image,
      overrideOnShow: onInfoDialogShow,
      buttonsInRow: buttonsInRow,
      reverseButtons: reverseButtons,
    );
  }

  static Future<void> notYetImplemented([String? contentName]) async {
    String message =
        contentName == null ? 'This feature is not yet implemented.\n\n이 기능은 준비중입니다.' : 'The $contentName feature is not yet implemented.';

    await infoDialog(
      title: 'Not Yet Implemented',
      message: message,
      image: Image.asset(
        'assets/images/icons/ui/ItemIcon_Hammer.Png',
        width: 120,
        height: 120,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  static Future<void> networkErrorDialog({VoidCallback? onClose}) async {
    String stackTrace = StackTrace.current.toString();
    _logger.severe('Failed to connect to the server. stackTrace: \n$stackTrace');

    await warningDialog(
      title: 'Network Error',
      message: 'Failed to connect to the server',
      onClose: onClose,
      actions: [
        PopupAction(
          text: 'Retry',
          onPressed: () {},
        ),
        PopupAction(
          text: 'Close',
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }

  static Future<void> messageDialog({
    required String title,
    String? message,
    List<TextSpan>? messageSpans,
    VoidCallback? overrideOnShow,
    VoidCallback? onClose,
    Widget? image,
    MessageType messageType = MessageType.info,
    List<PopupAction>? actions,
    int? buttonsInRow,
    bool reverseButtons = false,
  }) async {
    show(
      PopupMessage(
        title: title,
        message: message,
        messageSpans: messageSpans,
        messageType: messageType,
        onClose: onClose,
        image: image,
        actions: actions,
        buttonsInRow: buttonsInRow,
        reverseButtons: reverseButtons,
      ),
      //overrideOnShow: overrideOnShow,
    );
  }

  static Future<void> showOverlay(
    Widget overlayWidget, {
    bool showCloseButton = true,
    String? title,
    List<Widget>? buttons,
    VoidCallback? onClose,
    VoidCallback? overrideOnShow,
    Color? backgroundColor,
    double? width,
  }) async {
    currentType = PopupType.overlay;
    Popup.showCloseButton.value = showCloseButton;

    if (overrideOnShow != null) {
      overrideOnShow();
    } else {
      sfxOnOverlayShow?.call();
    }

    // UI 변경을 다음 프레임까지 지연시키기 위해 좀 기다림
    await SchedulerBinding.instance.endOfFrame;

    await Get.dialog(
      barrierColor: backgroundColor ?? transparentBlackW700,
      barrierDismissible: true,
      useSafeArea: false,
      PopupMaterial(
        animateScale: false,
        child: OverlayBase(
          title: title,
          buttons: buttons,
          width: width,
          onClose: onClose,
          child: overlayWidget,
        ),
      ),
    );
  }

  static Future<void> showFullscreen(
    Widget fullscreenWidget, {
    VoidCallback? overrideOnShow,
  }) async {
    currentType = PopupType.fullscreen;

    if (overrideOnShow != null) {
      overrideOnShow();
    } else {
      sfxOnFullscreenShow?.call();
    }

    // UI 변경을 다음 프레임까지 지연시키기 위해 좀 기다림
    await SchedulerBinding.instance.endOfFrame;

    await Get.to(
      () => fullscreenWidget,
      //transition: Transition.rightToLeftWithFade,
    );
  }
}
