import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_badge.dart';

class RestaurantTierCurrentSubscriptionCard extends StatelessWidget {
  const RestaurantTierCurrentSubscriptionCard({
    super.key,
    required this.optionsEntity,
    this.bundleName,
  });

  final SubscriptionUpgradeOptionsEntity optionsEntity;
  final String? bundleName;

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

    final tierCode = currentOption?.targetTier.isNotEmpty == true
        ? currentOption!.targetTier
        : optionsEntity.currentTier;
    final currentTierName = currentOption?.tierNameAr.isNotEmpty == true
        ? currentOption!.tierNameAr
        : tierCode;

    return Container(
      constraints: const BoxConstraints(
        minHeight: Spacing.restaurantTierPlanCardHeight,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.primaryContainer.withValues(alpha: 0.32),
        borderRadius: BorderRadius.circular(Spacing.restaurantTierCardRadius),
        border: Border.all(color: color.primaryContainer),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: locale.restaurant_tier_package_prefix),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: bundleName ?? '',
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size16,
                        color: color.primary,
                      ),
                    ),
                  ],
                ),
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size16,
                  color: color.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.sm,
                ),
                decoration: BoxDecoration(
                  color: color.primaryContainer,
                  borderRadius: BorderRadius.circular(Spacing.radiusMd),
                ),
                child: Text(
                  locale.restaurant_tier_active_label,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.primary,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    color: color.primary,
                    size: Spacing.iconSm,
                  ),
                  const SizedBox(width: Spacing.md),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: locale.restaurant_tier_remaining_prefix),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: optionsEntity.remainingServiceDays.toString(),
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size14,
                            color: color.primary,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: locale.restaurant_tier_remaining_days_suffix,
                        ),
                      ],
                    ),
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RestaurantTierBadge(imageUrl: currentOption?.logoUrl),
              const SizedBox(width: Spacing.sm),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: locale.restaurant_tier_current_label,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size14,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(text: currentTierName),
                  ],
                ),
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: color.onSurfaceVariant,
                size: Spacing.iconSm,
                semanticLabel:
                    locale.subscription_summary_restaurant_tier_label,
              ),
              const SizedBox(width: Spacing.xs),
              Flexible(
                child: Text(
                  locale.restaurant_tier_note,
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurfaceVariant,
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
