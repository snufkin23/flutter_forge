import 'package:flutter/material.dart';
import 'package:flutter_forge/core/constants/sizes.dart';
import 'package:flutter_forge/core/theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton._({
    required this.onPressed,
    this.label,
    this.icon,
    this.suffixIcon,
    this.isLoading = false,
    this.bgColor,
    this.fgColor,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.disabled = false,
    this.expanded = false,
    super.key,
  }) : assert(
          label != null || icon != null,
          'Either label or icon must be provided',
        );

  /// Default button — label and/or icon
  const factory CustomButton({
    required VoidCallback onPressed,
    String? label,
    Widget? icon,
    Widget? suffixIcon,
    bool isLoading,
    Color? bgColor,
    Color? fgColor,
    double? borderRadius,
    EdgeInsets? padding,
    double? width,
    double? height,
    bool disabled,
    bool expanded,
    Key? key,
  }) = CustomButton._;

  /// Text only button
  const factory CustomButton.text({
    required VoidCallback onPressed,
    required String label,
    bool isLoading,
    Color? bgColor,
    Color? fgColor,
    double? borderRadius,
    EdgeInsets? padding,
    double? width,
    double? height,
    bool disabled,
    bool expanded,
    Key? key,
  }) = CustomButton._;

  /// Icon only button
  const factory CustomButton.icon({
    required VoidCallback onPressed,
    required Widget icon,
    bool isLoading,
    Color? bgColor,
    Color? fgColor,
    double? borderRadius,
    EdgeInsets? padding,
    double? width,
    double? height,
    bool disabled,
    bool expanded,
    Key? key,
  }) = CustomButton._;

  /// Icon + Text button
  const factory CustomButton.iconText({
    required VoidCallback onPressed,
    required Widget icon,
    required String label,
    Widget? suffixIcon,
    bool isLoading,
    Color? bgColor,
    Color? fgColor,
    double? borderRadius,
    EdgeInsets? padding,
    double? width,
    double? height,
    bool disabled,
    bool expanded,
    Key? key,
  }) = CustomButton._;

  final VoidCallback onPressed;
  final String? label;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool isLoading;
  final Color? bgColor;
  final Color? fgColor;
  final double? borderRadius;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final bool expanded;
  final bool disabled;

  bool get _isEnabled => !disabled && !isLoading;

  @override
  Widget build(BuildContext context) {
    final double effectiveBorderRadius = borderRadius ?? AppSizes.radiusMd;
    final double effectiveHeight = height ?? AppSizes.buttonHeight;
    final EdgeInsets effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: AppSizes.xxl,
          vertical: AppSizes.md,
        );

    final ThemeData theme = Theme.of(context);

    final Color effectiveBg = disabled
        ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
        : (bgColor ?? theme.colorScheme.primary);

    final Color effectiveFg = disabled
        ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
        : (fgColor ?? theme.colorScheme.onPrimary);

    final Widget content = isLoading
        ? SizedBox(
            width: AppSizes.iconSm,
            height: AppSizes.iconSm,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: effectiveFg,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                icon!,
                if (label != null) SizedBox(width: AppSizes.sm),
              ],
              if (label != null)
                Flexible(
                  child: Text(
                    label!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: effectiveFg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (suffixIcon != null) ...<Widget>[
                SizedBox(width: AppSizes.sm),
                suffixIcon!,
              ],
            ],
          );

    return Material(
      color: effectiveBg,
      borderRadius: BorderRadius.circular(effectiveBorderRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _isEnabled ? onPressed : null,
        splashColor: effectiveFg.withValues(alpha: 0.16),
        highlightColor: effectiveFg.withValues(alpha: 0.10),
        child: SizedBox(
          height: effectiveHeight,
          width: expanded ? double.infinity : width,
          child: Padding(
            padding: effectivePadding,
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}
