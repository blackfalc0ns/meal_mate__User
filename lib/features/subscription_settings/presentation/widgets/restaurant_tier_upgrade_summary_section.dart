import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_section_card.dart';

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

    return RestaurantTierSectionCard(
      title: locale.upgrade_summary_operational_title,
      icon: Icons.schedule_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${locale.upgrade_summary_effective_date}: ${summary.effectiveFromDate}',
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurface,
            ),
          ),
          if (notice.isNotEmpty) ...[
            const SizedBox(height: Spacing.xs),
            Text(
              notice,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: Spacing.sm),
          Text(
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
          const SizedBox(height: Spacing.base),
          Text(
            locale.upgrade_summary_new_restaurants,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurface,
            ),
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
          else
            for (final restaurant in summary.newlyAddedRestaurants)
              Padding(
                padding: const EdgeInsets.only(bottom: Spacing.xs),
                child: Row(
                  children: [
                    Icon(
                      Icons.restaurant_rounded,
                      size: Spacing.iconSm,
                      color: color.primary,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        Directionality.of(context) == TextDirection.rtl
                            ? restaurant.nameAr
                            : restaurant.nameEn,
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      restaurant.rating.toStringAsFixed(1),
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
