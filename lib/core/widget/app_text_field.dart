import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// ─────────────────────────────────────────────────────────────
/// Reusable text field with consistent styling using AppColors.
/// ─────────────────────────────────────────────────────────────
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.hintStyle,
    this.errorText,
    this.errorMaxLines = 2,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.contentPadding,
    this.autofocus = false,
    this.fillColor,
    this.borderColor,
    this.borderRadius,
    this.textStyle,
    this.labelStyle,
    this.textAlign = TextAlign.start,
    this.autovalidateMode,
    this.isGlass = false,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final TextStyle? hintStyle;
  final String? errorText;
  final int? errorMaxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final bool autofocus;
  final Color? fillColor;
  final Color? borderColor;
  final double? borderRadius;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextAlign textAlign;
  final AutovalidateMode? autovalidateMode;
  final bool isGlass;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final effectiveRadius = borderRadius ?? Spacing.inputRadius;
    final inputBorderRadius = BorderRadius.circular(effectiveRadius);
    final effectiveBorderColor = isGlass
        ? color.surface.withValues(alpha: 0.52)
        : borderColor ?? AppColors.border;

    final textField = TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      autofocus: autofocus,
      textAlign: textAlign,
      autovalidateMode: autovalidateMode,
      style:
          textStyle ??
          getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size14,
            color: AppColors.textPrimary,
          ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        errorMaxLines: errorMaxLines,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isGlass
            ? color.surface.withValues(alpha: 0.42)
            : fillColor ?? AppColors.white,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.sm,
            ),
        labelStyle:
            labelStyle ??
            getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: AppColors.textSecondary,
            ),
        hintStyle:
            hintStyle ??
            getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: AppColors.textHint,
            ),
        errorStyle: getRegularStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size12,
          color: AppColors.error,
        ),
        border: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: BorderSide(
            color: effectiveBorderColor,
            width: Spacing.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: BorderSide(
            color: effectiveBorderColor,
            width: Spacing.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: const BorderSide(color: AppColors.disabled, width: 1.0),
        ),
      ),
    );

    if (!isGlass) {
      return textField;
    }

    return ClipRRect(
      borderRadius: inputBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: Spacing.xs, sigmaY: Spacing.xs),
        child: textField,
      ),
    );
  }
}
