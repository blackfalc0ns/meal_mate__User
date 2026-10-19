import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_meals_member_name_cell.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilyMealsMemberRow extends StatelessWidget {
  const FamilyMealsMemberRow({super.key, required this.member});

  final FamilyPlanMemberUiModel member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: 28,
      child: Row(
        children: [
          FamilyMealsMemberNameCell(member: member),
          for (final checked in member.mealChecks)
            Expanded(
              child: Icon(
                checked ? Icons.check_rounded : Icons.remove_rounded,
                color: checked ? color.primary : color.onSurfaceVariant,
                size: 16,
              ),
            ),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.xss,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color:
                      member.badgeColor ??
                      color.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(Spacing.radiusXs),
                ),
                child: Text(
                  member.mealsCount,
                  maxLines: 1,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    color: member.badgeTextColor ?? color.primary,
                    fontSize: FontSize.size9,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
