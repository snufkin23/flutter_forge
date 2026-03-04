import 'package:flutter/material.dart';
import 'package:flutter_forge/core/constants/sizes.dart';
import 'package:flutter_forge/core/theme/app_colors.dart';
import 'package:flutter_forge/core/theme/app_text_styles.dart';
import 'package:flutter_forge/core/widgets/custom_button.dart';
import 'package:flutter_forge/core/widgets/custom_outlined_button.dart';

class AppBottomSheet {
  const AppBottomSheet._();

  // —— Simple List ———————————————————————————————
  static Future<T?> list<T>(
    BuildContext context, {
    required List<AppBottomSheetItem<T>> items,
    String? title,
    bool showDividers = false,
  }) =>
      _show<T>(
        context,
        child: _ListBottomSheet<T>(
          items: items,
          title: title,
          showDividers: showDividers,
        ),
      );

  // —— Confirm Action ————————————————————————————
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDangerous = false,
    Widget? icon,
  }) =>
      _show<bool>(
        context,
        isDismissible: false,
        child: _ConfirmBottomSheet(
          title: title,
          message: message,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          isDangerous: isDangerous,
          icon: icon,
        ),
      );

  // —— Custom Content ————————————————————————————
  static Future<T?> custom<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool showDragHandle = true,
    EdgeInsets? padding,
  }) =>
      _show<T>(
        context,
        isDismissible: isDismissible,
        showDragHandle: showDragHandle,
        child: _CustomBottomSheet<T>(
          title: title,
          padding: padding,
          content: child,
        ),
      );

  // —— Draggable / Scrollable ————————————————————
  static Future<T?> draggable<T>(
    BuildContext context, {
    required Widget Function(ScrollController) builder,
    String? title,
    double initialSize = 0.5,
    double minSize = 0.25,
    double maxSize = 0.95,
    bool isDismissible = true,
    bool showDragHandle = true,
  }) =>
      showModalBottomSheet<T>(
        context: context,
        isDismissible: isDismissible,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => DraggableScrollableSheet(
          initialChildSize: initialSize,
          minChildSize: minSize,
          maxChildSize: maxSize,
          expand: false,
          builder: (_, ScrollController scrollController) => _BottomSheetContainer(
            showDragHandle: showDragHandle,
            child: Column(
              children: <Widget>[
                if (title != null) ...<Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.xxl,
                      AppSizes.lg,
                      AppSizes.xxl,
                      0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(title, style: AppTextStyles.titleLarge),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: AppSizes.lg),
                ],
                Expanded(child: builder(scrollController)),
              ],
            ),
          ),
        ),
      );

  // —— Private helper ————————————————————————————
  static Future<T?> _show<T>(
    BuildContext context, {
    required Widget child,
    bool isDismissible = true,
    bool showDragHandle = true,
  }) =>
      showModalBottomSheet<T>(
        context: context,
        isDismissible: isDismissible,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _BottomSheetContainer(
          showDragHandle: showDragHandle,
          child: child,
        ),
      );
}

// —— Bottom Sheet Container ————————————————————————————————————————————————
class _BottomSheetContainer extends StatelessWidget {
  const _BottomSheetContainer({
    required this.child,
    this.showDragHandle = true,
  });
  final Widget child;
  final bool showDragHandle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showDragHandle) ...<Widget>[
            const SizedBox(height: AppSizes.md),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightDivider,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
            ),
          ],
          child,
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

// —— List Bottom Sheet —————————————————————————————————————————————————————
class AppBottomSheetItem<T> {
  const AppBottomSheetItem({
    required this.label,
    required this.value,
    this.icon,
    this.color,
    this.isDestructive = false,
  });
  final String label;
  final IconData? icon;
  final T value;
  final Color? color;
  final bool isDestructive;
}

class _ListBottomSheet<T> extends StatelessWidget {
  const _ListBottomSheet({
    required this.items,
    this.title,
    this.showDividers = false,
  });
  final List<AppBottomSheetItem<T>> items;
  final String? title;
  final bool showDividers;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (title != null) ...<Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.xxl,
                vertical: AppSizes.sm,
              ),
              child: Text(
                title!,
                style: AppTextStyles.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(),
          ],
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => showDividers ? const Divider(height: 1) : const SizedBox(),
            itemBuilder: (_, int index) {
              final AppBottomSheetItem<T> item = items[index];
              final Color color = item.isDestructive
                  ? AppColors.error
                  : (item.color ?? Theme.of(context).colorScheme.onSurface);
              return ListTile(
                leading:
                    item.icon != null ? Icon(item.icon, color: color, size: AppSizes.iconMd) : null,
                title: Text(
                  item.label,
                  style: AppTextStyles.bodyLarge.copyWith(color: color),
                ),
                onTap: () => Navigator.of(context).pop(item.value),
              );
            },
          ),
        ],
      ),
    );
  }
}

// —— Confirm Bottom Sheet ——————————————————————————————————————————————————
class _ConfirmBottomSheet extends StatelessWidget {
  const _ConfirmBottomSheet({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.isDangerous = false,
    this.icon,
  });
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDangerous;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            icon!,
            const SizedBox(height: AppSizes.lg),
          ],
          Text(
            title,
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.lightSubtext,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.xxl),
          CustomButton.text(
            label: confirmLabel,
            bgColor: isDangerous ? AppColors.error : AppColors.primary,
            onPressed: () => Navigator.of(context).pop(true),
            expanded: true,
          ),
          const SizedBox(height: AppSizes.md),
          CustomOutlinedButton.text(
            label: cancelLabel,
            onPressed: () => Navigator.of(context).pop(false),
            expanded: true,
          ),
        ],
      ),
    );
  }
}

// —— Custom Bottom Sheet ———————————————————————————————————————————————————
class _CustomBottomSheet<T> extends StatelessWidget {
  const _CustomBottomSheet({
    required this.content,
    this.title,
    this.padding,
  });
  final String? title;
  final Widget content;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(AppSizes.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null) ...<Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title!, style: AppTextStyles.titleLarge),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
          ],
          content,
        ],
      ),
    );
  }
}
