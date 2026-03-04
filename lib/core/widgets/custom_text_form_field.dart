import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/core/constants/sizes.dart';
import 'package:flutter_forge/core/theme/app_colors.dart';
import 'package:flutter_forge/core/theme/app_text_styles.dart';

enum InputType { text, password, number, email, phone, multiline }

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.obscureText = false,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.suffixWidget,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.inputFormatters,
    this.focusNode,
    this.initialValue,
    this.errorText,
    this.helperText,
    this.fillColor,
    this.onTap,
  });

  // —— Text
  factory CustomTextFormField.text({
    String? label,
    String? hintText,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    TextInputAction? textInputAction,
    bool? enabled,
    bool? readOnly,
    String? initialValue,
    String? helperText,
    FocusNode? focusNode,
    Key? key,
  }) =>
      CustomTextFormField(
        key: key,
        label: label,
        hintText: hintText,
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        textInputAction: textInputAction,
        enabled: enabled ?? true,
        readOnly: readOnly ?? false,
        initialValue: initialValue,
        helperText: helperText,
        focusNode: focusNode,
      );

  // —— Password (manages obscure toggle internally)
  factory CustomTextFormField.password({
    String? label,
    String? hintText,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    TextInputAction? textInputAction,
    bool? enabled,
    FocusNode? focusNode,
    Key? key,
  }) =>
      CustomTextFormField(
        key: key,
        label: label,
        hintText: hintText,
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        textInputAction: textInputAction ?? TextInputAction.done,
        obscureText: true,
        enabled: enabled ?? true,
        focusNode: focusNode,
      );

  // —— Number
  factory CustomTextFormField.number({
    String? label,
    String? hintText,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    Key? key,
  }) =>
      CustomTextFormField(
        key: key,
        label: label,
        hintText: hintText,
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        maxLength: maxLength,
        inputFormatters:
            inputFormatters ?? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        enabled: enabled ?? true,
      );

  // —— Email
  factory CustomTextFormField.email({
    String? label,
    String? hintText,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    TextInputAction? textInputAction,
    bool? enabled,
    FocusNode? focusNode,
    Key? key,
  }) =>
      CustomTextFormField(
        key: key,
        label: label ?? 'Email',
        hintText: hintText ?? 'example@email.com',
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        keyboardType: TextInputType.emailAddress,
        textInputAction: textInputAction ?? TextInputAction.next,
        prefixIcon: Icons.email_outlined,
        enabled: enabled ?? true,
        focusNode: focusNode,
      );

  // —— Phone
  factory CustomTextFormField.phone({
    String? label,
    String? hintText,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    bool? enabled,
    Key? key,
  }) =>
      CustomTextFormField(
        key: key,
        label: label ?? 'Phone',
        hintText: hintText ?? '+977 98XXXXXXXX',
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        keyboardType: TextInputType.phone,
        prefixIcon: Icons.phone_outlined,
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        enabled: enabled ?? true,
      );

  // —— Multiline
  factory CustomTextFormField.multiline({
    String? label,
    String? hintText,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    int? maxLines,
    int? minLines,
    int? maxLength,
    bool? enabled,
    Key? key,
  }) =>
      CustomTextFormField(
        key: key,
        label: label,
        hintText: hintText,
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLines: maxLines ?? 5,
        minLines: minLines ?? 3,
        maxLength: maxLength,
        enabled: enabled ?? true,
      );

  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final Widget? suffixIcon;
  final Widget? suffixWidget;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final String? initialValue;
  final String? errorText;
  final String? helperText;
  final Color? fillColor;
  final VoidCallback? onTap;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscure() => setState(() => _obscureText = !_obscureText);

  Widget? get _suffixIcon {
    // Password toggle takes priority
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: AppSizes.iconMd,
          color: AppColors.lightSubtext,
        ),
        onPressed: _toggleObscure,
      );
    }

    // Custom suffix widget
    if (widget.suffixWidget != null) {
      return widget.suffixWidget;
    }

    // Custom suffix icon
    return widget.suffixIcon;
  }

  Widget? get _prefixIcon {
    if (widget.prefixWidget != null) {
      return widget.prefixWidget;
    }
    if (widget.prefixIcon != null) {
      return Icon(
        widget.prefixIcon,
        size: AppSizes.iconMd,
        color: AppColors.lightSubtext,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      onTap: widget.onTap,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscureText,
      maxLength: widget.maxLength,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      inputFormatters: widget.inputFormatters,
      focusNode: widget.focusNode,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        errorText: widget.errorText,
        helperText: widget.helperText,
        prefixIcon: _prefixIcon,
        suffixIcon: _suffixIcon,
        filled: widget.fillColor != null,
        fillColor: widget.fillColor,
        counterText: widget.maxLength != null ? null : '',
      ),
    );
  }
}
