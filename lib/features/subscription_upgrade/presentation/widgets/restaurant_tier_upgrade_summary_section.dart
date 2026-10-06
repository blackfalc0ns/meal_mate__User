import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_section_card.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_upgrade_restaurant_item.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_upgrade_restaurants_sheet.dart';

class RestaurantTierUpgradeSummarySection extends StatelessWidget {
  const RestaurantTierUpgradeSummarySection({super.key, required this.summary});

  final SubscriptionUpgradeSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final notice = Directionality.of(context) == TextDirection.rtl
        ? summary.effectiveNoticeAr
        : summary.effectiveNoticeEn;

    final displayedRestaurants = summary.newlyAddedRestaurants.take(3).toList();
    final hasMoreRestaurants = summary.newlyAddedRestaurants.length > 3;

    return RestaurantTierSectionCard(
      title: locale.upgrade_summary_operational_title,
      icon: Icons.schedule_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: color.surfaceContainerLowest,
              border: Border.all(color: color.outlineVariant),
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.event_available_rounded,
                      size: Spacing.iconSm,
                      color: color.primary,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        '${locale.upgrade_summary_effective_date}: ${summary.effectiveFromDate}',
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size12,
                          color: color.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                if (notice.isNotEmpty) ...[
                  const SizedBox(height: Spacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: color.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(Spacing.radiusXs),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: Spacing.iconSm,
                          color: color.primary,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Expanded(
                          child: Text(
                            notice,
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size10,
                              color: color.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: Spacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.repeat_rounded,
                      size: Spacing.iconSm,
                      color: color.onSurfaceVariant,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        locale.upgrade_summary_repetition(
                          summary.restaurantRepetition.limit,
                          summary.restaurantRepetition.durationDays,
                        ),
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Icon(
                Icons.restaurant_rounded,
                size: Spacing.iconSm,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: Text(
                  locale.upgrade_summary_new_restaurants,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
              ),
              if (summary.newlyAddedRestaurants.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: color.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                  child: Text(
                    '+${summary.newlyAddedRestaurants.length}',
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          if (summary.newlyAddedRestaurants.isEmpty)
            Text(
              locale.upgrade_summary_no_new_restaurants,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurfaceVariant,
              ),
            )
          else ...[
            for (var i = 0; i < displayedRestaurants.length; i++) ...[
              if (i > 0) const SizedBox(height: Spacing.xs),
              RestaurantTierUpgradeRestaurantItem(
                restaurant: displayedRestaurants[i],
              ),
            ],
            if (hasMoreRestaurants) ...[
              const SizedBox(height: Spacing.sm),
              AppButton.outlined(
                text: locale.upgrade_summary_view_more_restaurants,
                onPressed: () => RestaurantTierUpgradeRestaurantsSheet.show(
                  context: context,
                  restaurants: summary.newlyAddedRestaurants,
                ),
                height: Spacing.buttonSmallHeight,
                borderRadius: Spacing.radiusPill,
                color: color.primary,
                textColor: color.primary,
                fontSize: FontSize.size12,
                icon: Icons.keyboard_arrow_down_rounded,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
