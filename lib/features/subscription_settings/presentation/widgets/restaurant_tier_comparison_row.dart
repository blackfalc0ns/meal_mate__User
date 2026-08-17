import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_badge.dart';

class RestaurantTierComparisonRow extends StatelessWidget {
  const RestaurantTierComparisonRow({super.key, required this.row});

  final RestaurantTierComparisonRowEntity row;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: Spacing.restaurantTierActionPanelHeight,
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RestaurantTierBadge(
                  imageAsset: row.badgeAsset,
                  size: Spacing.iconLg,
                ),
                const SizedBox(width: Spacing.xs),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '${row.packageLabel} '),
                        TextSpan(
                          text: row.tierName,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size13,
                            color: color.onSurface,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size13,
                      color: color.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.md),
          SizedBox(
            height: Spacing.xxl,
            child: VerticalDivider(color: color.outlineVariant),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '${row.restaurantCountPrefix} '),
                      TextSpan(
                        text: row.restaurantCount,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size12,
                          color: color.primary,
                        ),
                      ),
                      TextSpan(text: ' ${row.restaurantCountSuffix}'),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                Text(
                  row.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size8,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Icon(
            Icons.arrow_back_ios_new_rounded,
            color: color.primary,
            size: Spacing.iconSm,
            semanticLabel: locale.subscription_summary_restaurant_tier_label,
          ),
        ],
      ),
    );
  }
}
