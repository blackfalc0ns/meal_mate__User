import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/models/family_restaurants_view_data.dart';
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

    final selectedInt = int.tryParse(summary.selectedMeals) ?? 0;
    final totalInt =
        int.tryParse(
          summary.selectedMealsTotal.replaceAll(RegExp(r'[^\d]'), ''),
        ) ??
        1;
    final progressValue = totalInt > 0
        ? (selectedInt / totalInt).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      height: Spacing.familyRestaurantsSummaryHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.familyRestaurantsSummaryRadius,
        ),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.06),
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
              SizedBox.square(
                dimension: 44.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progressValue,
                      strokeWidth: 3.5,
                      backgroundColor: color.surfaceContainerHighest,
                      color: color.primary,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: summary.selectedMeals,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size13,
                              color: color.primary,
                            ),
                          ),
                          TextSpan(
                            text: summary.selectedMealsTotal,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size13,
                              color: color.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.xxs),
              Text(
                summary.selectedMealsLabel,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(width: Spacing.xs),
          Expanded(
            child: Row(
              children: [
                FamilyRestaurantsSummaryMetric(
                  value: summary.dailyMeals,
                  label: summary.dailyMealsLabel,
                  icon: Icons.restaurant_rounded,
                ),
                SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    width: Spacing.unit,
                    thickness: Spacing.border,
                    color: color.outlineVariant,
                  ),
                ),
                FamilyRestaurantsSummaryMetric(
                  value: summary.calories,
                  label: summary.caloriesLabel,
                  icon: Icons.local_fire_department_rounded,
                ),
                SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    width: Spacing.unit,
                    thickness: Spacing.border,
                    color: color.outlineVariant,
                  ),
                ),
                FamilyRestaurantsSummaryMetric(
                  value: '',
                  label: summary.programLabel,
                  icon: Icons.balance_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.xs),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color.surfaceContainerHighest,
                child: Icon(
                  Icons.person_rounded,
                  size: Spacing.iconLg,
                  color: color.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.xxs),
              Text(
                memberName,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
