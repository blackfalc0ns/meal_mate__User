import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_restaurant_circle_avatar.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_restaurants_sheet.dart';

class SubscriptionParticipatingRestaurantsCard extends StatelessWidget {
  const SubscriptionParticipatingRestaurantsCard({
    super.key,
    required this.restaurants,
    required this.totalCount,
  });

  final List<SubscriptionSummaryRestaurantEntity> restaurants;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final displayedRestaurants = restaurants.take(5).toList();
    final effectiveTotal = totalCount > 0 ? totalCount : restaurants.length;
    final remainingCount = effectiveTotal > displayedRestaurants.length
        ? effectiveTotal - displayedRestaurants.length
        : 0;

    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant, width: Spacing.border),
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: Spacing.avatarSm,
                height: Spacing.avatarSm,
                decoration: BoxDecoration(
                  color: color.primaryContainer,
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.storefront_rounded,
                  color: color.primary,
                  size: Spacing.iconSm,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  locale.subscription_participating_restaurants,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              if (restaurants.isNotEmpty)
                Material(
                  color: color.primaryContainer,
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    onTap: () {
                      unawaited(
                        SubscriptionSummaryRestaurantsSheet.show(
                          context: context,
                          restaurants: restaurants,
                          totalCount: effectiveTotal,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                        vertical: Spacing.xss,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            locale.subscription_view_all,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size10,
                              color: color.primary,
                            ),
                          ),
                          const SizedBox(width: Spacing.xxs),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: Spacing.iconXs,
                            color: color.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: Spacing.base),
          if (displayedRestaurants.isNotEmpty)
            Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final restaurant in displayedRestaurants)
                  SubscriptionRestaurantCircleAvatar(
                    logoUrl: restaurant.logoUrl,
                  ),
                if (remainingCount > 0)
                  Container(
                    width: Spacing.avatarMd,
                    height: Spacing.avatarMd,
                    decoration: BoxDecoration(
                      color: color.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '+$remainingCount',
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.primary,
                      ),
                    ),
                  ),
              ],
            )
          else
            Text(
              locale.subscription_no_restaurants_for_area,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
