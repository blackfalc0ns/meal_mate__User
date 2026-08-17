import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_feature_chip.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_preview.dart';

class RestaurantTierUpgradeHeroCard extends StatelessWidget {
  const RestaurantTierUpgradeHeroCard({super.key, required this.data});

  final RestaurantTierUpgradeEntity data;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.primaryContainer.withValues(alpha: 0.16),
        border: Border.all(color: color.primaryContainer),
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              data.currentPackageLabel,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Row(
            children: [
              Expanded(child: RestaurantTierPreview(tier: data.currentTier)),
              Icon(
                Icons.arrow_back_ios_new_rounded,
                color: color.primary,
                size: Spacing.iconLg,
                semanticLabel:
                    locale.subscription_summary_restaurant_tier_label,
              ),
              Expanded(child: RestaurantTierPreview(tier: data.newTier)),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: data.features
                .map(
                  (feature) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xs,
                      ),
                      child: RestaurantTierFeatureChip(feature: feature),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
