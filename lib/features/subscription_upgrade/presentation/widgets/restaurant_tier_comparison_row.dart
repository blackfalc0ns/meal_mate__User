import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_badge.dart';

class RestaurantTierComparisonRow extends StatelessWidget {
  const RestaurantTierComparisonRow({
    super.key,
    required this.packageLabel,
    required this.tierName,
    required this.badgeAsset,
    this.imageUrl,
    required this.restaurantCount,
    required this.caption,
    this.restaurantCountPrefix,
    this.restaurantCountSuffix,
  });

  final String packageLabel;
  final String tierName;
  final String badgeAsset;
  final String? imageUrl;
  final String restaurantCount;
  final String caption;
  final String? restaurantCountPrefix;
  final String? restaurantCountSuffix;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final prefix = restaurantCountPrefix ?? locale.restaurant_tier_about_prefix;
    final suffix =
        restaurantCountSuffix ?? locale.restaurant_tier_restaurants_suffix;

    return SizedBox(
      height: Spacing.restaurantTierActionPanelHeight,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RestaurantTierBadge(imageUrl: imageUrl, badgeAsset: badgeAsset),
                const SizedBox(width: Spacing.xs),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '$packageLabel '),
                        TextSpan(
                          text: tierName,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onSurface,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.xs),
          SizedBox(
            height: Spacing.xl,
            child: VerticalDivider(color: color.outlineVariant),
          ),
          const SizedBox(width: Spacing.xs),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '$prefix '),
                      TextSpan(
                        text: restaurantCount,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.primary,
                        ),
                      ),
                      TextSpan(text: ' $suffix'),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurface,
                  ),
                ),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size9,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.xs),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: color.primary,
            size: Spacing.iconSm,
            semanticLabel: locale.subscription_summary_restaurant_tier_label,
          ),
        ],
      ),
    );
  }
}
