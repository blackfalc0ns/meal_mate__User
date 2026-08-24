import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_overview_section.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilyPaymentMealOverviewSection extends StatelessWidget {
  const FamilyPaymentMealOverviewSection({super.key, required this.summary});

  final FamilySummaryEntity? summary;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    color.surface;
    locale.localeName;
    final members = _mealOverviewMembers(context);

    if (members.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: Spacing.lg),
        FamilyPaymentOverviewSection(members: members),
      ],
    );
  }

  List<FamilyPlanMemberUiModel> _mealOverviewMembers(BuildContext context) {
    final locale = context.localization;
    final data = summary;
    if (data == null || data.mealOverview.isEmpty) {
      return const [];
    }

    return data.mealOverview.map((item) {
      final mealsCount = item.mealsPerDay > 0
          ? '+${item.mealsPerDay} ${locale.family_manage_meals}'
          : '';
      return FamilyPlanMemberUiModel(
        name: item.displayName,
        imageAsset: '',
        isOwner: item.isManager,
        mealChecks: item.mealChecks,
        mealsCount: mealsCount,
      );
    }).toList();
  }
}
