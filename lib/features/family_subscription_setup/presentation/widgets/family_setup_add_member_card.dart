import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilySetupAddMemberCard extends StatelessWidget {
  const FamilySetupAddMemberCard({
    super.key,
    this.label,
    this.isSelected = false,
    this.onTap,
  });

  final String? label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final text = label ?? locale.family_members_add_member;

    return Semantics(
      button: true,
      selected: isSelected,
      label: text,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: Spacing.familyProgramMemberCardWidth,
          height: Spacing.familyProgramMemberCardHeight,
          decoration: BoxDecoration(
            color: isSelected
                ? color.primary.withValues(alpha: 0.08)
                : color.surface,
            border: Border.all(
              color: isSelected ? color.primary : color.outlineVariant,
              width: isSelected ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(
              Spacing.familyProgramMemberCardRadius,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Spacing.familyProgramStepCircleSize,
                height: Spacing.familyProgramStepCircleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? color.primary : color.outlineVariant,
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  Icons.add_rounded,
                  size: Spacing.iconSm,
                  color: color.primary,
                ),
              ),
              const SizedBox(height: Spacing.xss),
              Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size9,
                  color: isSelected ? color.primary : color.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
