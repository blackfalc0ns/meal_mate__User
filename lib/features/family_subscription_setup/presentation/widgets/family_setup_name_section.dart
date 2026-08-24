import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';

class FamilySetupNameSection extends StatelessWidget {
  const FamilySetupNameSection({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.family_name,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        AppTextField(
          controller: controller,
          hint: locale.family_name_hint,
          prefixIcon: Icon(
            Icons.groups_2_rounded,
            color: color.onSurfaceVariant,
            size: Spacing.iconSm,
          ),
          onSubmitted: (_) => onSubmitted(),
        ),
      ],
    );
  }
}
