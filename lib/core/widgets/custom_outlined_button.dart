import 'package:flutter/material.dart';
import 'package:flutter_forge/core/constants/sizes.dart';
import 'package:flutter_forge/core/theme/app_colors.dart';
import 'package:flutter_forge/core/theme/app_text_styles.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton._({
    required this.onPressed,
    this.label,
    this.icon,
    this.suffixIcon,
    bool? isLoading,
    this.borderColor,
    this.fgColor,
    this.fillColor,
    double? borderRadius,
    double? borderWidth,
    EdgeInsets? padding,
    this.width,
    double? height,
    bool? disabled,
    bool? expanded,
    super.key,
  })  : isLoading = isLoading ?? false,
        borderRadius = borderRadius ?? AppSizes.radiusMd,
        borderWidth = borderWidth ?? 1.5,
        padding = padding ??
            const EdgeInsets.symmetric(
              horizontal: AppSizes.xxl,
              vertical: AppSizes.md,
            ),
        height = height ?? AppSizes.buttonHeight,
        expanded = expanded ?? false,
        disabled = disabled ?? false,
        assert(
          label != null || icon != null,
          'Either label or icon must be provided',
        );

  /// Default — label and/or icon
  const factory CustomOutlinedButton({
    required VoidCallback onPressed,
    String? label,
    Widget? icon,
    Widget? suffixIcon,
    bool? isLoading,
    Color? borderColor,
    Color? fgColor,
    Color? fillColor,
    double? borderRadius,
    double? borderWidth,
    EdgeInsets? padding,
    double? width,
    double? height,
    bool? disabled,
    bool? expanded,
    Key? key,
  }) = CustomOutlinedButton._;

  /// Text only
  const factory CustomOutlinedButton.text({
    required VoidCallback onPressed,
    required String label,
    bool? isLoading,
    Color? borderColor,
    Color? fgColor,
    Color? fillColor,
    double? borderRadius,
    double? borderWidth,
    EdgeInsets? padding,
    double? width,
    double? height,
    bool? disabled,
    bool? expanded,
    Key? key,
  }) = CustomOutlinedButton._;

  /// Icon only
  const factory CustomOutlinedButton.icon({
    required VoidCallback onPressed,
    required Widget icon,
    bool? isLoading,
    Color? borderColor,
    Color? fgColor,
    Color? fillColor,
    double? borderRadius,
    double? borderWidth,
    EdgeInsets? padding,
    double? width,
    double? height,
    bool? disabled,
    bool? expanded,
    Key? key,
  }) = CustomOutlinedButton._;

  /// Icon + Text
  const factory CustomOutlinedButton.iconText({
    required VoidCallback onPressed,
    required Widget icon,
    required String label,
    Widget? suffixIcon,
    bool? isLoading,
    Color? borderColor,
    Color? fgColor,
    Color? fillColor,
    double? borderRadius,
    double? borderWidth,
    EdgeInsets? padding,
    double? width,
    double? height,
    bool? disabled,
    bool? expanded,
    Key? key,
  }) = CustomOutlinedButton._;

  final VoidCallback onPressed;
  final String? label;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool isLoading;
  final Color? borderColor;
  final Color? fgColor;
  final Color? fillColor;
  final double borderRadius;
  final double borderWidth;
  final EdgeInsets padding;
  final double? width;
  final double height;
  final bool expanded;
  final bool disabled;

  bool get _isEnabled => !disabled && !isLoading;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color effectiveBorderColor = disabled
        ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
        : (borderColor ?? AppColors.primary);

    final Color effectiveFg = disabled
        ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
        : (fgColor ?? AppColors.primary);

    final Color effectiveFill = fillColor ?? Colors.transparent;

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
                if (label != null) const SizedBox(width: AppSizes.sm),
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
                const SizedBox(width: AppSizes.sm),
                suffixIcon!,
              ],
            ],
          );

    return Material(
      color: effectiveFill,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
      ),
      child: InkWell(
        onTap: _isEnabled ? onPressed : null,
        splashColor: effectiveFg.withValues(alpha: 0.08),
        highlightColor: effectiveFg.withValues(alpha: 0.06),
        child: SizedBox(
          height: height,
          width: expanded ? double.infinity : width,
          child: Padding(
            padding: padding,
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}
