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
  });

  final String label;
  final String hint;
  final IconData icon;
  final IconData? trailing;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

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
          height: Spacing.familySetupInputHeight,
          child: AppTextField(
            hint: hint,
            textAlign: TextAlign.right,
            borderRadius: Spacing.familySetupInputRadius,
            borderColor: color.outlineVariant,
            fillColor: color.surface,
            suffixIcon: trailing == null
                ? null
                : Icon(
                    trailing,
                    size: Spacing.iconSm,
                    color: color.onSurfaceVariant,
                  ),
            prefixIcon: suffix == null
                ? null
                : Container(
                    width: 35,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(Spacing.border),
                    decoration: BoxDecoration(
                      color: color.outlineVariant,
                      borderRadius: const BorderRadiusDirectional.horizontal(
                        start: Radius.circular(Spacing.radiusSm),
                      ),
                    ),
                    child: Text(
                      suffix!,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ),
            contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.md),
            hintStyle: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.onSurfaceVariant.withValues(alpha: 0.48),
            ),
            textStyle: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
