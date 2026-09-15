import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';

class InfluencerWithdrawInputField extends StatelessWidget {
  const InfluencerWithdrawInputField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.start,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        AppTextField(
          controller: controller,
          hint: hint,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          validator: validator,
          suffixIcon: suffixIcon,
          fillColor: color.surface,
          borderColor: color.outlineVariant,
          borderRadius: Spacing.inputRadius,
          textStyle: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: color.onSurface,
          ),
          hintStyle: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: color.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Spacing.base,
            vertical: Spacing.md,
          ),
        ),
      ],
    );
  }
}
