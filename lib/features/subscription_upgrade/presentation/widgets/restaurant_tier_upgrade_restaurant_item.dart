import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';

class RestaurantTierUpgradeRestaurantItem extends StatelessWidget {
  const RestaurantTierUpgradeRestaurantItem({
    super.key,
    required this.restaurant,
  });

  final SubscriptionUpgradeRestaurantEntity restaurant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final name = isRtl
        ? (restaurant.nameAr.isNotEmpty ? restaurant.nameAr : restaurant.nameEn)
        : (restaurant.nameEn.isNotEmpty
              ? restaurant.nameEn
              : restaurant.nameAr);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
      ),
      child: Row(
        children: [
          Container(
            width: Spacing.avatarSm,
            height: Spacing.avatarSm,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color.outlineVariant,
                width: Spacing.border,
              ),
            ),
            child: ClipOval(
              child: AppCachedNetworkImage(
                imageUrl: restaurant.logoUrl,
                width: Spacing.avatarSm,
                height: Spacing.avatarSm,
                shape: BoxShape.circle,
                fit: BoxFit.cover,
                semanticLabel: name,
                errorWidget: Icon(
                  Icons.restaurant_rounded,
                  color: color.primary,
                  size: Spacing.iconSm,
                ),
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                if (restaurant.tier.isNotEmpty) ...[
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    restaurant.tier,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (restaurant.rating > 0) ...[
            const SizedBox(width: Spacing.xs),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  color: color.primary,
                  size: Spacing.iconSm,
                  semanticLabel: locale.search_rating,
                ),
                const SizedBox(width: Spacing.xxs),
                Text(
                  restaurant.rating.toStringAsFixed(1),
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
