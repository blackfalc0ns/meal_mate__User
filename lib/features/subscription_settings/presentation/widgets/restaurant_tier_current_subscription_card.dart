import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_badge.dart';

class RestaurantTierCurrentSubscriptionCard extends StatelessWidget {
  const RestaurantTierCurrentSubscriptionCard({super.key, required this.data});

  final RestaurantTierUpgradeEntity data;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.restaurantTierPlanCardHeight,
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
        children: [
          Row(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: data.packagePrefix),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: data.mealsCount,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size16,
                        color: color.primary,
                      ),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(text: data.mealsSuffix),
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
                  data.activeLabel,
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
                        TextSpan(text: data.remainingPrefix),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: data.remainingDays,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size14,
                            color: color.primary,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(text: data.remainingSuffix),
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
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RestaurantTierBadge(
                imageAsset: data.tiers.first.badgeAsset,
                size: Spacing.restaurantTierSmallBadgeSize,
              ),
              const SizedBox(width: Spacing.sm),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: data.currentLabel,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size14,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(text: data.currentTierName),
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
          const Spacer(),
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
                  data.note,
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
