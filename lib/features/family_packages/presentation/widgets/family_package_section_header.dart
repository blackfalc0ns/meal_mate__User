import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyPackageSectionHeader extends StatelessWidget {
  const FamilyPackageSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: Spacing.avatarSm,
          height: Spacing.avatarSm,
          decoration: BoxDecoration(
            color: color.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.groups_rounded,
            color: color.onPrimary,
            size: Spacing.iconSm,
          ),
        ),
        const SizedBox(width: Spacing.sm),

        Text(
          locale.family_packages_section_title,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size16,
            color: color.onSurface,
          ),
        ),
      ],
    );
  }
}
