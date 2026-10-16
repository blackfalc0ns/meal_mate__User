import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';

class FamilySetupField extends StatelessWidget {
  const FamilySetupField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.trailing,
    this.suffix,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.onChanged,
    this.isLoading = false,
    this.errorText,
  });

  final String label;
  final String hint;
  final IconData icon;
  final IconData? trailing;
  final String? suffix;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool isLoading;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    Widget? suffixWidget;
    if (isLoading) {
      suffixWidget = Padding(
        padding: const EdgeInsets.all(Spacing.sm),
        child: SizedBox(
          width: Spacing.iconSm,
          height: Spacing.iconSm,
          child: CircularProgressIndicator(
            strokeWidth: Spacing.border * 2,
            color: color.primary,
          ),
        ),
      );
    } else if (suffix != null) {
      suffixWidget = Container(
        width: 48,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(Spacing.hairline),
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest.withValues(alpha: 0.7),
          borderRadius: const BorderRadiusDirectional.horizontal(
            end: Radius.circular(Spacing.familySetupInputRadius),
          ),
        ),
        child: Text(
          suffix!,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: color.onSurfaceVariant,
          ),
        ),
      );
    } else if (trailing != null) {
      suffixWidget = Icon(
        trailing,
        size: Spacing.iconSm,
        color: color.onSurfaceVariant,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: Spacing.iconSm, color: color.primary),
            const SizedBox(width: Spacing.xs),
            Text(
              label,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.xss),
        SizedBox(
          height: errorText != null ? null : Spacing.familySetupInputHeight,
          child: AppTextField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            onChanged: onChanged,
            hint: hint,
            errorText: errorText,
            textAlign: TextAlign.start,
            borderRadius: Spacing.familySetupInputRadius,
            borderColor: color.outlineVariant,
            fillColor: color.surface,
            suffixIcon: suffixWidget,
            contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.md),
            hintStyle: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant.withValues(alpha: 0.48),
            ),
            textStyle: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
