import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/helpers/restaurant_tier_helpers.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_feature_chip.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_preview.dart';

class RestaurantTierUpgradeHeroCard extends StatelessWidget {
  const RestaurantTierUpgradeHeroCard({
    super.key,
    required this.optionsEntity,
    required this.selectedOption,
    this.programName,
  });

  final SubscriptionUpgradeOptionsEntity optionsEntity;
  final SubscriptionUpgradeOptionEntity selectedOption;
  final String? programName;

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

    final diffRestaurants =
        selectedOption.accessibleRestaurantCount -
        (currentOption?.accessibleRestaurantCount ?? 0);

    final extraRestaurantsLabel = diffRestaurants > 0
        ? locale.restaurant_tier_extra_restaurants_count(diffRestaurants)
        : locale.restaurant_tier_restaurants_count_only(
            selectedOption.accessibleRestaurantCount,
          );

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.primaryContainer.withValues(alpha: 0.16),
        border: Border.all(color: color.primaryContainer),
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
      ),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              programName ?? locale.restaurant_tier_current_package_label,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RestaurantTierPreview(
                  name: currentTierName,
                  badgeAsset: currentBadgeAsset,
                  imageUrl: currentOption?.logoUrl,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: color.primary,
                size: Spacing.iconMd,
                semanticLabel:
                    locale.subscription_summary_restaurant_tier_label,
              ),
              Expanded(
                child: RestaurantTierPreview(
                  name: newTierName,
                  badgeAsset: newBadgeAsset,
                  imageUrl: selectedOption.logoUrl,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                  child: RestaurantTierFeatureChip(
                    icon: Icons.add_rounded,
                    label: extraRestaurantsLabel,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                  child: RestaurantTierFeatureChip(
                    icon: Icons.emoji_events_rounded,
                    label: locale.restaurant_tier_feature_distinctive,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                  child: RestaurantTierFeatureChip(
                    icon: Icons.restaurant_rounded,
                    label: locale.restaurant_tier_feature_wider_options,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
