import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_meals_table.dart';

class FamilyMealsTableSection extends StatelessWidget {
  const FamilyMealsTableSection({super.key, required this.members});

  final List<FamilyPlanMemberUiModel> members;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.family_overview_title,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        FamilyMealsTable(members: members),
      ],
    );
  }
}

typedef FamilyPaymentOverviewSection = FamilyMealsTableSection;
