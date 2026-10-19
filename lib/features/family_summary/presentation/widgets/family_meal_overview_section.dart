import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_meals_table_section.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

class FamilyMealOverviewSection extends StatelessWidget {
  const FamilyMealOverviewSection({
    super.key,
    required this.summary,
    this.flowMembers = const [],
  });

  final FamilySummaryEntity? summary;
  final List<FamilyMemberEntity> flowMembers;

  @override
  Widget build(BuildContext context) {
    final members = _mealOverviewMembers(context);

    if (members.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: Spacing.lg),
        FamilyMealsTableSection(members: members),
      ],
    );
  }

  List<FamilyPlanMemberUiModel> _mealOverviewMembers(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    final data = summary;
    if (data == null || data.mealOverview.isEmpty) {
      return const [];
    }

    final flowMemberMap = {for (final m in flowMembers) m.memberId: m};
    return data.mealOverview.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final matchingMember = flowMemberMap[item.memberId];
      final isManager =
          item.isManager ||
          (matchingMember?.isManager ?? false) ||
          (flowMembers.firstOrNull?.memberId == item.memberId) ||
          index == 0;
      final isSubscribed = matchingMember?.subscribeNow ?? false;

      final mealsCount = !isSubscribed
          ? locale.family_member_unsubscribed_status
          : item.mealsPerDay > 0
          ? '+${item.mealsPerDay} ${locale.family_manage_meals}'
          : '';
      return FamilyPlanMemberUiModel(
        name: item.displayName,
        imageAsset: '',
        isOwner: isManager,
        mealChecks: isSubscribed
            ? item.mealChecks
            : const [false, false, false, false],
        mealsCount: mealsCount,
        badgeColor: !isSubscribed ? color.surfaceContainerHighest : null,
        badgeTextColor: !isSubscribed ? color.onSurfaceVariant : null,
      );
    }).toList();
  }
}

typedef FamilyPaymentMealOverviewSection = FamilyMealOverviewSection;
