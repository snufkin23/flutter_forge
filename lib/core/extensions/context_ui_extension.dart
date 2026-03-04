import 'package:flutter/material.dart';
import 'package:flutter_forge/core/widgets/widgets.dart';

extension ContextUIExtension on BuildContext {
  // ————————————————————————————————————————————————
  // SNACKBAR
  // ————————————————————————————————————————————————

  void showSuccessSnackbar(
    String message, {
    SnackbarPosition position = SnackbarPosition.bottom,
    SnackbarAlignment alignment = SnackbarAlignment.center,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      AppSnackbar.success(
        this,
        message,
        position: position,
        alignment: alignment,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  void showErrorSnackbar(
    String message, {
    SnackbarPosition position = SnackbarPosition.bottom,
    SnackbarAlignment alignment = SnackbarAlignment.center,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      AppSnackbar.error(
        this,
        message,
        position: position,
        alignment: alignment,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  void showWarningSnackbar(
    String message, {
    SnackbarPosition position = SnackbarPosition.bottom,
    SnackbarAlignment alignment = SnackbarAlignment.center,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      AppSnackbar.warning(
        this,
        message,
        position: position,
        alignment: alignment,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  void showInfoSnackbar(
    String message, {
    SnackbarPosition position = SnackbarPosition.bottom,
    SnackbarAlignment alignment = SnackbarAlignment.center,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      AppSnackbar.info(
        this,
        message,
        position: position,
        alignment: alignment,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  // ————————————————————————————————————————————————
  // DIALOG
  // ————————————————————————————————————————————————

  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    Color? confirmColor,
    bool isDangerous = false,
  }) =>
      AppDialog.confirm(
        this,
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        confirmColor: confirmColor,
        isDangerous: isDangerous,
      );

  Future<void> showInfoDialog({
    required String title,
    required String message,
    String closeLabel = 'Got it',
    Widget? icon,
  }) =>
      AppDialog.info(
        this,
        title: title,
        message: message,
        closeLabel: closeLabel,
        icon: icon,
      );

  Future<String?> showPromptDialog({
    required String title,
    String? message,
    String? hintText,
    String? initialValue,
    String confirmLabel = 'Submit',
    String cancelLabel = 'Cancel',
    FormFieldValidator<String>? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    int? maxLines,
  }) =>
      AppDialog.prompt(
        this,
        title: title,
        message: message,
        hintText: hintText,
        initialValue: initialValue,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
      );

  Future<T?> showCustomDialog<T>({
    required Widget content,
    String? title,
    bool barrierDismissible = true,
    EdgeInsets? contentPadding,
    double? maxWidth,
  }) =>
      AppDialog.custom<T>(
        this,
        content: content,
        title: title,
        barrierDismissible: barrierDismissible,
        contentPadding: contentPadding,
        maxWidth: maxWidth,
      );

  // ————————————————————————————————————————————————
  // BOTTOM SHEET
  // ————————————————————————————————————————————————

  Future<T?> showListBottomSheet<T>({
    required List<AppBottomSheetItem<T>> items,
    String? title,
    bool showDividers = false,
  }) =>
      AppBottomSheet.list<T>(
        this,
        items: items,
        title: title,
        showDividers: showDividers,
      );

  Future<bool?> showConfirmBottomSheet({
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDangerous = false,
    Widget? icon,
  }) =>
      AppBottomSheet.confirm(
        this,
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDangerous: isDangerous,
        icon: icon,
      );

  Future<T?> showCustomBottomSheet<T>({
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool showDragHandle = true,
    EdgeInsets? padding,
  }) =>
      AppBottomSheet.custom<T>(
        this,
        child: child,
        title: title,
        isDismissible: isDismissible,
        showDragHandle: showDragHandle,
        padding: padding,
      );

  Future<T?> showDraggableBottomSheet<T>({
    required Widget Function(ScrollController) builder,
    String? title,
    double initialSize = 0.5,
    double minSize = 0.25,
    double maxSize = 0.95,
    bool isDismissible = true,
    bool showDragHandle = true,
  }) =>
      AppBottomSheet.draggable<T>(
        this,
        builder: builder,
        title: title,
        initialSize: initialSize,
        minSize: minSize,
        maxSize: maxSize,
        isDismissible: isDismissible,
        showDragHandle: showDragHandle,
      );
}
