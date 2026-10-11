import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/helpers/restaurant_tier_helpers.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_comparison_row.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_section_card.dart';

class RestaurantTierQuickComparisonSection extends StatelessWidget {
  const RestaurantTierQuickComparisonSection({
    super.key,
    required this.optionsEntity,
    required this.selectedOption,
  });

  final SubscriptionUpgradeOptionsEntity optionsEntity;
  final SubscriptionUpgradeOptionEntity selectedOption;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    SubscriptionUpgradeOptionEntity? currentOption;
    for (final opt in optionsEntity.options) {
      if (opt.isCurrent) {
        currentOption = opt;
        break;
      }
    }

    final currentTierCode = currentOption?.targetTier.isNotEmpty == true
        ? currentOption!.targetTier
        : optionsEntity.currentTier;
    final currentTierName = currentOption?.tierNameAr.isNotEmpty == true
        ? currentOption!.tierNameAr
        : (currentOption?.tierNameEn.isNotEmpty == true
              ? currentOption!.tierNameEn
              : currentTierCode);
    final currentBadgeAsset = RestaurantTierHelpers.badgeAssetForIndex(0);

    final newTierName = selectedOption.tierNameAr.isNotEmpty
        ? selectedOption.tierNameAr
        : (selectedOption.tierNameEn.isNotEmpty
              ? selectedOption.tierNameEn
              : selectedOption.targetTier);
    final newBadgeAsset = RestaurantTierHelpers.badgeAssetForIndex(1);

    return Semantics(
      label: locale.subscription_summary_restaurant_tier_label,
      child: RestaurantTierSectionCard(
        title: locale.restaurant_tier_quick_comparison_title,
        icon: Icons.bar_chart_rounded,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
          decoration: BoxDecoration(
            border: Border.all(color: color.outlineVariant),
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
          ),
          child: Column(
            children: [
              RestaurantTierComparisonRow(
                packageLabel: locale.restaurant_tier_current_package_label,
                tierName: currentTierName,
                badgeAsset: currentBadgeAsset,
                imageUrl: currentOption?.logoUrl,
                restaurantCount:
                    '${currentOption?.accessibleRestaurantCount ?? 0}+',
                caption: locale.restaurant_tier_your_current_tier,
              ),
              Divider(height: Spacing.zero, color: color.outlineVariant),
              RestaurantTierComparisonRow(
                packageLabel: locale.restaurant_tier_new_package_label,
                tierName: newTierName,
                badgeAsset: newBadgeAsset,
                imageUrl: selectedOption.logoUrl,
                restaurantCount: '${selectedOption.accessibleRestaurantCount}+',
                caption: locale.restaurant_tier_includes_all_format(
                  currentTierName,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
