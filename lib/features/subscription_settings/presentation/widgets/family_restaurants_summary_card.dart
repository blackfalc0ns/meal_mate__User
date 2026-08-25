import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_restaurants_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_restaurants_summary_metric.dart';

class FamilyRestaurantsSummaryCard extends StatelessWidget {
  const FamilyRestaurantsSummaryCard({
    super.key,
    required this.memberName,
    required this.summary,
  });

  final String memberName;
  final FamilyRestaurantsSummaryData summary;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    locale.localeName;

    return Container(
      height: Spacing.familyRestaurantsSummaryHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.familyRestaurantsSummaryRadius,
        ),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, Spacing.xs),
            blurRadius: Spacing.xs,
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: Spacing.iconLg,
                backgroundColor: color.surfaceContainerHighest,
                child: Icon(
                  Icons.person_rounded,
                  size: Spacing.iconXl,
                  color: color.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                memberName,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size17,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(width: Spacing.lg),
          Expanded(
            child: Row(
              children: [
                FamilyRestaurantsSummaryMetric(
                  value: summary.programLabel,
                  label: summary.programLabel,
                  icon: Icons.balance_rounded,
                ),
                VerticalDivider(color: color.outlineVariant),
                FamilyRestaurantsSummaryMetric(
                  value: summary.calories,
                  label: summary.caloriesLabel,
                  icon: Icons.local_fire_department_rounded,
                ),
                VerticalDivider(color: color.outlineVariant),
                FamilyRestaurantsSummaryMetric(
                  value: summary.dailyMeals,
                  label: summary.dailyMealsLabel,
                  icon: Icons.restaurant_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.sm),
          SizedBox.square(
            dimension: Spacing.avatarLg,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.67,
                  strokeWidth: Spacing.sm,
                  backgroundColor: color.surfaceContainerHighest,
                  color: color.primary,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: summary.selectedMeals,
                        children: [
                          TextSpan(
                            text: summary.selectedMealsTotal,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size15,
                              color: color.primary,
                            ),
                          ),
                        ],
                      ),
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size15,
                        color: color.onSurface,
                      ),
                    ),
                    Text(
                      summary.selectedMealsLabel,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size9,
                        color: color.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
