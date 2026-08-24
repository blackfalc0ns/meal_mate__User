import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilySetupAddMemberCard extends StatelessWidget {
  const FamilySetupAddMemberCard({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.familySetupMemberCardHeight,
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(
          Spacing.familySetupMemberCardRadius,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Spacing.familySetupAddIconSize,
            height: Spacing.familySetupAddIconSize,
            decoration: BoxDecoration(
              border: Border.all(color: color.onSurfaceVariant),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_rounded,
              color: color.primary,
              size: Spacing.iconMd,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            label,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size8,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
