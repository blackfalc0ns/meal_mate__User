import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_restaurants_sheet.dart';

class SubscriptionParticipatingRestaurantsCard extends StatelessWidget {
  const SubscriptionParticipatingRestaurantsCard({
    super.key,
    required this.restaurants,
    required this.totalCount,
  });

  final List<SubscriptionSummaryRestaurantEntity> restaurants;
  final int totalCount;

  static const List<String> _fallbackLogos = [
    AssetsFake.burgerKingLogo,
    AssetsFake.starbucksLogo,
    AssetsFake.saladBowl,
    AssetsFake.mcdonaldsLogo,
  ];

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final displayCount = totalCount > 0 ? totalCount : 100;
    final remainingCount = displayCount > 5 ? displayCount - 5 : 0;
    final badgeText = remainingCount > 0
        ? '+$remainingCount'
        : '+$displayCount';

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
                    fontSize: FontSize.size16,
                    color: color.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
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
                            fontSize: FontSize.size12,
                            color: color.primary,
                          ),
                        ),
                        const SizedBox(width: Spacing.xxs),
                        Icon(
                          isRtl
                              ? Icons.chevron_left_rounded
                              : Icons.chevron_right_rounded,
                          size: Spacing.iconSm,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < 5; i++)
                _buildRestaurantCircle(context: context, index: i),
              Container(
                width: Spacing.avatarMd,
                height: Spacing.avatarMd,
                decoration: BoxDecoration(
                  color: color.primaryContainer,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  badgeText,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCircle({
    required BuildContext context,
    required int index,
  }) {
    final color = context.colorScheme;
    final hasRestaurant = index < restaurants.length;
    final restaurant = hasRestaurant ? restaurants[index] : null;
    final logoUrl = restaurant?.logoUrl;

    Widget imageContent;
    if (logoUrl != null && logoUrl.trim().isNotEmpty) {
      imageContent = AppCachedNetworkImage(
        imageUrl: logoUrl,
        fit: BoxFit.cover,
      );
    } else {
      final fallbackAsset = _fallbackLogos[index % _fallbackLogos.length];
      imageContent = Image.asset(fallbackAsset, fit: BoxFit.contain);
    }

    return Container(
      width: Spacing.avatarMd,
      height: Spacing.avatarMd,
      decoration: BoxDecoration(
        color: color.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.hairline,
        ),
      ),
      padding: const EdgeInsets.all(Spacing.xs),
      child: ClipOval(child: imageContent),
    );
  }
}
