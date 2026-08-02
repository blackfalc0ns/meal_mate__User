import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_plan_entity.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_meals_table.dart';

class FamilyPaymentOverviewSection extends StatelessWidget {
  const FamilyPaymentOverviewSection({super.key, required this.members});

  final List<FamilyMemberEntity> members;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      children: [
        Text(
          locale.family_overview_title,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: color.primary,
          ),
        ),
        const SizedBox(height: Spacing.xxl),
        FamilyMealsTable(members: members),
      ],
    );
  }
}
