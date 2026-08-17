import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_comparison_row.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_section_card.dart';

class RestaurantTierQuickComparisonSection extends StatelessWidget {
  const RestaurantTierQuickComparisonSection({super.key, required this.data});

  final RestaurantTierUpgradeEntity data;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.subscription_summary_restaurant_tier_label,
      child: RestaurantTierSectionCard(
        title: data.quickComparisonTitle,
        icon: Icons.bar_chart_rounded,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
          decoration: BoxDecoration(
            border: Border.all(color: color.outlineVariant),
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
          ),
          child: Column(
            children: [
              for (
                var index = 0;
                index < data.quickComparisonRows.length;
                index++
              )
                Column(
                  children: [
                    RestaurantTierComparisonRow(
                      row: data.quickComparisonRows[index],
                    ),
                    if (index != data.quickComparisonRows.length - 1)
                      Divider(
                        height: Spacing.zero,
                        color: color.outlineVariant,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
