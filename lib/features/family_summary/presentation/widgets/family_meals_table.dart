import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_meals_member_row.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_meals_table_divider.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_meals_table_row.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilyMealsTable extends StatelessWidget {
  const FamilyMealsTable({super.key, required this.members});

  final List<FamilyPlanMemberUiModel> members;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final color = context.colorScheme;
    final columns = [
      l10n.family_table_member,
      l10n.family_table_breakfast,
      l10n.family_table_lunch,
      l10n.family_table_snack,
      l10n.family_table_dinner,
      l10n.family_table_meals_count,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xs,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.restaurant_rounded,
                size: Spacing.iconSm,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.xss),
              Text(
                l10n.family_meals_each_member,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xss),
          FamilyMealsTableRow(cells: columns, isHeader: true),
          for (final member in members) ...[
            const FamilyMealsTableDivider(),
            FamilyMealsMemberRow(member: member),
          ],
        ],
      ),
    );
  }
}
