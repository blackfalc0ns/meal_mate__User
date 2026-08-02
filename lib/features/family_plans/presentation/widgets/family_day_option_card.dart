import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/data/family_program_setup_fake_data.dart';

class FamilyDayOptionCard extends StatelessWidget {
  const FamilyDayOptionCard({
    super.key,
    required this.option,
    required this.onTap,
  });

  final FamilyDayOptionFakeData option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final selected = option.isSelected;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.sm),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: Spacing.familyDayOptionHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected
                  ? color.surfaceContainerHighest.withValues(alpha: 0.25)
                  : color.surface,
              border: Border.all(
                color: selected ? color.primary : color.outlineVariant,
                width: selected
                    ? Spacing.familySelectedBorderWidth
                    : Spacing.border,
              ),
              borderRadius: BorderRadius.circular(Spacing.sm),
            ),
            child: Text(
              option.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: selected ? color.primary : color.onSurfaceVariant,
              ),
            ),
          ),
          if (selected)
            PositionedDirectional(
              top: -Spacing.md,
              end: -Spacing.xs,
              child: CircleAvatar(
                radius: Spacing.md,
                backgroundColor: color.primary,
                child: Icon(
                  Icons.check_rounded,
                  size: Spacing.iconSm,
                  color: color.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
