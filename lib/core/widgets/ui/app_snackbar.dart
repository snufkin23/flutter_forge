import 'package:flutter/material.dart';
import 'package:flutter_forge/core/constants/constants.dart';
import 'package:flutter_forge/core/theme/theme.dart';

enum SnackbarType { success, error, warning, info }

enum SnackbarPosition { top, bottom }

enum SnackbarAlignment { left, center, right }

class AppSnackbar {
  const AppSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    SnackbarPosition position = SnackbarPosition.bottom,
    SnackbarAlignment alignment = SnackbarAlignment.center,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    bool dismissible = true,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _SnackbarContent(message: message, type: type),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        dismissDirection:
            dismissible ? DismissDirection.horizontal : DismissDirection.none,
        margin: _resolveMargin(position, alignment),
        padding: EdgeInsets.zero,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.transparent,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }

  static void success(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.bottom,
    SnackbarAlignment alignment = SnackbarAlignment.center,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      show(
        context,
        message: message,
        type: SnackbarType.success,
        position: position,
        alignment: alignment,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  static void error(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.bottom,
    SnackbarAlignment alignment = SnackbarAlignment.center,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      show(
        context,
        message: message,
        type: SnackbarType.error,
        position: position,
        alignment: alignment,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  static void warning(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.bottom,
    SnackbarAlignment alignment = SnackbarAlignment.center,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      show(
        context,
        message: message,
        type: SnackbarType.warning,
        position: position,
        alignment: alignment,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  static void info(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.bottom,
    SnackbarAlignment alignment = SnackbarAlignment.center,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      show(
        context,
        message: message,
        position: position,
        alignment: alignment,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  static EdgeInsets _resolveMargin(
    SnackbarPosition position,
    SnackbarAlignment alignment,
  ) {
    final double side = AppSizes.lg;
    final double bottom = AppSizes.xxxl;
    final double top = AppSizes.xxxxxl;

    final double leftMargin =
        alignment == SnackbarAlignment.right ? AppSizes.xxxxl : side;
    final double rightMargin =
        alignment == SnackbarAlignment.left ? AppSizes.xxxxl : side;

    return position == SnackbarPosition.top
        ? EdgeInsets.only(
            top: top,
            left: leftMargin,
            right: rightMargin,
          )
        : EdgeInsets.only(
            bottom: bottom,
            left: leftMargin,
            right: rightMargin,
          );
  }
}

class _SnackbarContent extends StatelessWidget {
  const _SnackbarContent({
    required this.message,
    required this.type,
  });
  final String message;
  final SnackbarType type;

  Color get _bgColor => switch (type) {
        SnackbarType.success => const Color(0xFF2E7D32),
        SnackbarType.error => AppColors.error,
        SnackbarType.warning => const Color(0xFFE65100),
        SnackbarType.info => const Color(0xFF1565C0),
      };

  IconData get _icon => switch (type) {
        SnackbarType.success => Icons.check_circle_rounded,
        SnackbarType.error => Icons.error_rounded,
        SnackbarType.warning => Icons.warning_rounded,
        SnackbarType.info => Icons.info_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.md,
      ),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: _bgColor.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(_icon, color: Colors.white, size: AppSizes.iconMd),
          SizedBox(width: AppSizes.sm),
          Flexible(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
