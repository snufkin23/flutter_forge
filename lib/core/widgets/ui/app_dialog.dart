import 'package:flutter/material.dart';
import 'package:flutter_forge/core/constants/sizes.dart';
import 'package:flutter_forge/core/theme/app_colors.dart';
import 'package:flutter_forge/core/theme/app_text_styles.dart';
import 'package:flutter_forge/core/widgets/custom_button.dart';
import 'package:flutter_forge/core/widgets/custom_outlined_button.dart';

class AppDialog {
  const AppDialog._();

  // —— Confirm / Cancel ——————————————————————————
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    Color? confirmColor,
    bool isDangerous = false,
  }) =>
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _ConfirmDialog(
          title: title,
          message: message,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          confirmColor: confirmColor,
          isDangerous: isDangerous,
        ),
      );

  // —— Info ——————————————————————————————————————
  static Future<void> info(
    BuildContext context, {
    required String title,
    required String message,
    String closeLabel = 'Got it',
    Widget? icon,
  }) =>
      showDialog<void>(
        context: context,
        builder: (_) => _InfoDialog(
          title: title,
          message: message,
          closeLabel: closeLabel,
          icon: icon,
        ),
      );

  // —— Input Prompt ——————————————————————————————
  static Future<String?> prompt(
    BuildContext context, {
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
      showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _PromptDialog(
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
        ),
      );

  // —— Custom Content ————————————————————————————
  static Future<T?> custom<T>(
    BuildContext context, {
    required Widget content,
    String? title,
    bool barrierDismissible = true,
    EdgeInsets? contentPadding,
    double? maxWidth,
  }) =>
      showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) => _CustomDialog<T>(
          title: title,
          contentPadding: contentPadding,
          maxWidth: maxWidth,
          content: content,
        ),
      );
}

// —— Confirm Dialog ————————————————————————————————————————————————————————
class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.confirmColor,
    this.isDangerous = false,
  });
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Color? confirmColor;
  final bool isDangerous;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (isDangerous)
              const Padding(
                padding: EdgeInsets.only(bottom: AppSizes.md),
                child: Icon(
                  Icons.warning_rounded,
                  color: AppColors.error,
                  size: AppSizes.iconXl,
                ),
              ),
            Text(title, style: AppTextStyles.titleLarge),
            const SizedBox(height: AppSizes.sm),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.lightSubtext,
              ),
            ),
            const SizedBox(height: AppSizes.xxl),
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomOutlinedButton.text(
                    label: cancelLabel,
                    onPressed: () => Navigator.of(context).pop(false),
                    expanded: true,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: CustomButton.text(
                    label: confirmLabel,
                    bgColor: confirmColor ?? (isDangerous ? AppColors.error : AppColors.primary),
                    onPressed: () => Navigator.of(context).pop(true),
                    expanded: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// —— Info Dialog ————————————————————————————————————————————————————————————
class _InfoDialog extends StatelessWidget {
  const _InfoDialog({
    required this.title,
    required this.message,
    required this.closeLabel,
    this.icon,
  });
  final String title;
  final String message;
  final String closeLabel;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
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
              label: closeLabel,
              onPressed: () => Navigator.of(context).pop(),
              expanded: true,
            ),
          ],
        ),
      ),
    );
  }
}

// —— Prompt Dialog ——————————————————————————————————————————————————————————
class _PromptDialog extends StatefulWidget {
  const _PromptDialog({
    required this.title,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.keyboardType,
    required this.obscureText,
    this.message,
    this.hintText,
    this.initialValue,
    this.validator,
    this.maxLines,
  });
  final String title;
  final String? message;
  final String? hintText;
  final String? initialValue;
  final String confirmLabel;
  final String cancelLabel;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLines;

  @override
  State<_PromptDialog> createState() => _PromptDialogState();
}

class _PromptDialogState extends State<_PromptDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xxl),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.title, style: AppTextStyles.titleLarge),
              if (widget.message != null) ...<Widget>[
                const SizedBox(height: AppSizes.xs),
                Text(
                  widget.message!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.lightSubtext,
                  ),
                ),
              ],
              const SizedBox(height: AppSizes.lg),
              TextFormField(
                controller: _controller,
                validator: widget.validator,
                keyboardType: widget.keyboardType,
                obscureText: widget.obscureText,
                maxLines: widget.obscureText ? 1 : widget.maxLines,
                autofocus: true,
                onFieldSubmitted: (_) => _onSubmit(),
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                ),
              ),
              const SizedBox(height: AppSizes.xxl),
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomOutlinedButton.text(
                      label: widget.cancelLabel,
                      onPressed: () => Navigator.of(context).pop(),
                      expanded: true,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: CustomButton.text(
                      label: widget.confirmLabel,
                      onPressed: _onSubmit,
                      expanded: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// —— Custom Dialog ——————————————————————————————————————————————————————————
class _CustomDialog<T> extends StatelessWidget {
  const _CustomDialog({
    required this.content,
    this.title,
    this.contentPadding,
    this.maxWidth,
  });
  final String? title;
  final Widget content;
  final EdgeInsets? contentPadding;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? 400,
        ),
        child: Padding(
          padding: contentPadding ?? const EdgeInsets.all(AppSizes.xxl),
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
        ),
      ),
    );
  }
}
